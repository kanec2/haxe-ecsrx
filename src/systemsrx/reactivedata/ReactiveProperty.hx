package systemsrx.reactivedata;

#if (concurrent || sys)
import rx.Observable;
import rx.Observer;
import rx.observers.IObserver;
import rx.disposables.ISubscription;
import rx.disposables.CompositeDisposable;
import rx.Subject;
import hx.concurrent.atomic.AtomicInt; // Для атомарных операций

#end
// import haxe.ds.Equality; // Для сравнения, если нужно

/** 
 * Lightweight property broker. 
 * This code is adapted from UniRx project by neuecc (https://github.com/neuecc/UniRx). 
 * @typeparam T The type of the value. 
 */
@:keep // Чтобы класс не был удален DCE
class ReactiveProperty<T> implements IReactiveProperty<T> {
	#if (concurrent || sys)
	// Используем простое сравнение по умолчанию
	// static final defaultEqualityComparer:T->T->Bool = function(a:T, b:T) return a == b;
	// Или если нужна более точная семантика, как EqualityComparer<T>.Default:
	// static final defaultEqualityComparer:T->T->Bool = haxe.ds.Equality.equals; // Если доступно
	// В Haxe нет прямого эквивалента [NonSerialized], но мы можем использовать runtime проверки
	// или просто управлять состоянием вручную.
	var canPublishValueOnSubscribe:Bool = false;
	var isDisposed:Bool = false;
	var _value:T = null; // default(T) в C# для ссылочных типов null, для значимых - значение по умолчанию

	var publisher:Subject<T> = null;
	var sourceConnection:ISubscription = null;
	var lastException:Dynamic = null; // Используем Dynamic для исключения

	// В Haxe protected virtual методы не поддерживаются напрямую как в C#.
	// Мы можем использовать private и предоставить методы для переопределения через наследование.
	// function get_equalityComparer():T->T->Bool return defaultEqualityComparer;
	// Для простоты будем использовать == или Equality.equals
	// Реализация IReactiveProperty<T>
	public var value(get, set):T;

	function get_value():T {
		return _value;
	}

	function set_value(val:T):T {
		if (!canPublishValueOnSubscribe) {
			canPublishValueOnSubscribe = true;
			setValue(val);

			if (isDisposed) {
				return val;
			}

			var p = publisher;
			if (p != null) {
				// Используем правильное имя метода из RxHaxe Subject
				p.on_next(_value);
			}
			return val;
		}

		// Используем простое сравнение. Для более сложных типов может потребоваться кастомный компаратор.
		// if (get_equalityComparer()(_value, val)) {
		if (_value == val || (_value != null && val != null && _value == val)) { // Простая проверка
			return val;
		}
		{
			setValue(val);

			if (isDisposed)
				return val;
			var p = publisher;
			if (p != null) {
				p.on_next(_value);
			}
		}
		return val;
	}

	// Реализация IReadOnlyReactiveProperty<T>
	public var hasValue(get, null):Bool;

	function get_hasValue():Bool {
		return canPublishValueOnSubscribe;
	}

	// Реализация Observable<T>
	public function subscribe(observer:IObserver<T>):ISubscription {
		if (lastException != null) {
			observer.on_error(Std.string(lastException)); // Преобразуем в строку для on_error
			return rx.Subscription.create(() -> {}); // Пустая подписка
		}

		if (isDisposed) {
			observer.on_completed();
			return rx.Subscription.create(() -> {});
		}

		if (publisher == null) {
			// В C# был Interlocked.CompareExchange, здесь просто присваиваем.
			// В многопоточной среде это может быть не атомарно, но для простоты так.
			publisher = new rx.Subject<T>(); // Subject.create<T>()
		}

		var p = publisher;
		if (p != null) {
			var subscription:ISubscription = p.subscribe(observer);
			if (canPublishValueOnSubscribe) {
				observer.on_next(_value); // raise latest value on subscribe
			}
			return subscription;
		} else {
			observer.on_completed();
			return rx.Subscription.create(() -> {});
		}
	}

	// Конструкторы
	public function new(?initialValue:T = null) {
		if (initialValue != null) { // Проверяем, был ли передан initialValue
			setValue(initialValue);
			canPublishValueOnSubscribe = true;
		} else {
			// default constructor 'can' publish value on subscribe.
			// because sometimes value is deserialized from UnityEngine.
			// В Haxe просто оставляем значения по умолчанию
			// _value уже null/default
			// canPublishValueOnSubscribe = false; // По умолчанию
		}
	}

	// Конструктор из Observable
	public function fromObservable(source:Observable<T>) {
		// initialized from source's ReactiveProperty `doesn't` publish value on subscribe.
		// because there ReactiveProperty is `Future/Task/Promise`.
		canPublishValueOnSubscribe = false;

		// sourceConnection = source.subscribe(new ReactivePropertyObserver(this));
		// В Haxe создаем observer через функции, используя Observer.create
		sourceConnection = source.subscribe(Observer.create( // onCompleted
			function():Void {
				handleSourceCompleted();
			}, // onError
			function(error:String):Void {
				handleSourceError(error); // Предполагая, что handleSourceError принимает String
			}, // onNext
			function(v:T):Void {
				// onNext
				this.value = v; // Это вызовет сеттер value, который обработает логику
			}));
	}

	// Конструктор из Observable с начальным значением
	public function fromObservableWithInitial(source:Observable<T>, initialValue:T) {
		canPublishValueOnSubscribe = false;
		this.value = initialValue; // Value set canPublishValueOnSubscribe = true

		// sourceConnection = source.subscribe(new ReactivePropertyObserver(this));
		sourceConnection = source.subscribe(Observer.create( // onCompleted
			function():Void {
				handleSourceCompleted();
			}, // onError
			function(error:String):Void {
				handleSourceError(error); // Предполагая, что handleSourceError принимает String
			}, // onNext
			function(v:T):Void {
				this.value = v;
			}));
	}

	// Вспомогательные методы (protected virtual в C#)
	function setValue(val:T):Void {
		this._value = val;
	}

	public function setValueAndForceNotify(val:T):Void {
		setValue(val);

		if (isDisposed) {
			return;
		}

		var p = publisher;
		if (p != null) {
			p.on_next(_value);
		}
	}

	// IDisposable
	public function dispose():Void {
		disposeInternal(true);
		// GC.SuppressFinalize(this); // В Haxe нет необходимости
	}

	function disposeInternal(disposing:Bool):Void {
		if (isDisposed) {
			return;
		}
		isDisposed = true;
		var sc = sourceConnection;
		if (sc != null) {
			sc.unsubscribe(); // Используем правильное имя метода
			sourceConnection = null;
		}
		var p = publisher;
		if (p == null) {
			return;
		}
		// when dispose, notify OnCompleted
		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;
		try {
			p.on_completed(); // Используем правильное имя метода
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		// Завершающие действия вне блока try
		p.on_completed(); // Subject может требовать on_completed перед dispose
		// p.dispose(); // Subject в RxHaxe может не иметь dispose, или он может быть в ISubscription
		// Предположим, что Subject сам управляет ресурсами или unsubscribe() достаточно
		publisher = null;

		// Если была ошибка, пробрасываем её
		if (hasError) {
			throw errorValue;
		}
	}

	// Обработчики ошибок и завершения источника
	function handleSourceError(error:String):Void {
		// В C# использовался Interlocked.Increment. В Haxe для простоты используем флаг.
		// Предположим, что ошибки источника обрабатываются один раз.
		if (lastException != null)
			return; // Уже была ошибка

		lastException = error;
		var p = publisher;
		if (p != null) {
			p.on_error(error);
		}
		dispose(); // complete subscription
	}

	function handleSourceCompleted():Void {
		// source was completed but can publish from .Value yet.
		var sc = sourceConnection;
		sourceConnection = null;
		if (sc != null) {
			sc.unsubscribe();
		}
	}

	public function toString():String {
		return (_value == null) ? "(null)" : Std.string(_value);
	}

	// public function isRequiredSubscribeOnCurrentThread():Bool {
	// В оригинале всегда возвращал false. В Haxe можно убрать или оставить.
	// return false;
	// }
	// Вложенный класс-наблюдатель из C# кода
	/*
		private class ReactivePropertyObserver implements IObserver<T> { 
		// В Haxe вложенные классы не поддерживаются напрямую в этом синтаксисе. 
		// Лучше реализовать логику через замыкания в методе subscribe или как отдельный класс. 
		// Мы реализовали логику напрямую в методах fromObservable. 
		} 
	 */
	#else
	// Заглушка для платформ без поддержки
	public var value(get, set):T;

	function get_value():T
		return cast null;

	function set_value(val:T):T
		return val;

	public var hasValue(get, null):Bool;

	function get_hasValue():Bool
		return false;

	public function new(?initialValue:T = null) {}

	public function fromObservable(source:Dynamic) {}

	public function fromObservableWithInitial(source:Dynamic, initialValue:T) {}

	public function subscribe(observer:rx.observers.IObserver<T>):rx.disposables.ISubscription {
		return null;
	}

	public function setValueAndForceNotify(val:T):Void {}

	public function dispose():Void {}

	public function toString():String
		return "";

	function setValue(val:T):Void {}

	function disposeInternal(disposing:Bool):Void {}

	function handleSourceError(error:String):Void {}

	function handleSourceCompleted():Void {}
	#end
}