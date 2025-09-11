package systemsrx.reactivedata.dictionaries;

#if (concurrent || sys)
import rx.Observable;
import rx.Subject;
import rx.disposables.ISubscription;
import haxe.ds.Map;
// Используем Map из Haxe вместо Dictionary
#end
import systemsrx.computeds.Unit;

// Используем Unit из computeds

/** * Reactive dictionary implementation. * This code is adapted from UniRx project by neuecc (https://github.com/neuecc/UniRx). * @typeparam TKey The type of keys in the dictionary. * @typeparam TValue The type of values in the dictionary. */
@:keep class ReactiveDictionary<TKey, TValue> implements IReactiveDictionary<TKey, TValue> {
	#if (concurrent || sys)
	var isDisposed:Bool = false;
	var inner:Map<TKey, TValue> = null;
	// Внутреннее хранилище элементов
	// Subjects for notifications
	var countChanged:Subject<Int> = null;
	var collectionReset:Subject<Unit> = null;
	var dictionaryAdd:Subject<DictionaryAddEvent<TKey, TValue>> = null;
	var dictionaryRemove:Subject<DictionaryRemoveEvent<TKey, TValue>> = null;
	var dictionaryReplace:Subject<DictionaryReplaceEvent<TKey, TValue>> = null;

	public function new(?comparer:TKey->TKey->Int) {
		// comparer в Haxe может быть функцией
		this.inner = new Map<TKey, TValue>();
		this.isDisposed = false;
		// В Haxe Map не принимает comparer напрямую в конструкторе
		// Логика сравнения ключей встроена в Map
	}

	// Конструктор из существующего Map
	public function fromMap(innerMap:Map<TKey, TValue>) {
		this.inner = innerMap;
		this.isDisposed = false;
	}

	// Реализация IReactiveDictionary<TKey, TValue> и IReadOnlyReactiveDictionary<TKey, TValue>
	// Доступ к элементам
	public function get(key:TKey):TValue {
		if (!inner.exists(key)) {
			throw 'Key not found: $key';
		}
		return inner.get(key);
	}

	public function set(key:TKey, value:TValue):TValue {
		if (inner.exists(key)) {
			var oldValue = inner.get(key);
			inner.set(key, value);
			if (dictionaryReplace != null) {
				dictionaryReplace.on_next(new DictionaryReplaceEvent<TKey, TValue>(key, oldValue, value));
			}
		} else {
			inner.set(key, value);
			if (dictionaryAdd != null) {
				dictionaryAdd.on_next(new DictionaryAddEvent<TKey, TValue>(key, value));
			}
			if (countChanged != null) {
				countChanged.on_next(count);
			}
		}
		return value;
	}

	// Длина словаря
	public var count(get, null):Int;

	function get_count():Int {
		return inner.keys().toArray().length;
		// Map в Haxe не имеет прямого свойства length
	}

	// Ключи и значения
	public var keys(get, null):Iterable<TKey>;

	function get_keys():Iterable<TKey> {
		return inner.keys();
	}

	public var values(get, null):Iterable<TValue>;

	function get_values():Iterable<TValue> {
		return [for (v in inner) v];
		// Итерация по значениям
	}

	// Методы для изменения словаря
	public function add(key:TKey, value:TValue):Void {
		if (inner.exists(key)) {
			throw 'An item with the same key has already been added. Key: $key';
		}
		inner.set(key, value);
		if (dictionaryAdd != null) {
			dictionaryAdd.on_next(new DictionaryAddEvent<TKey, TValue>(key, value));
		}
		if (countChanged != null) {
			countChanged.on_next(count);
		}
	}

	public function clear():Void {
		var beforeCount = count;
		inner.clear();
		// Простая очистка Map
		if (collectionReset != null) {
			collectionReset.on_next(Unit.instance);
			// Используем Unit.instance
		}
		if (beforeCount > 0 && countChanged != null) {
			countChanged.on_next(count);
		}
	}

	public function remove(key:TKey):Bool {
		if (!inner.exists(key)) {
			return false;
		}
		var oldValue = inner.get(key);
		var isSuccessRemove = inner.remove(key);
		if (!isSuccessRemove) {
			return isSuccessRemove;
		}
		if (dictionaryRemove != null) {
			dictionaryRemove.on_next(new DictionaryRemoveEvent<TKey, TValue>(key, oldValue));
		}
		if (countChanged != null) {
			countChanged.on_next(count);
		}
		return isSuccessRemove;
	}

	// Методы для проверки
	public function containsKey(key:TKey):Bool {
		return inner.exists(key);
	}

	public function tryGetValue(key:TKey, value:Ref<TValue>):Bool {
		if (inner.exists(key)) {
			if (value != null) {
				value.value = inner.get(key);
			}
			return true;
		}
		if (value != null) {
			value.value = null;
		}
		return false;
	}

	// Observable методы
	public function observeCountChanged():Observable<Int> {
		if (isDisposed) {
			return Observable.empty();
			// ImmutableEmptyObservable<Int>.Instance в C#
		}
		var subject = countChanged;
		if (subject == null) {
			subject = countChanged = new rx.Subject<Int>();
			// Subject.create<Int>()
		}
		return subject;
	}

	public function observeReset():Observable<Unit> {
		if (isDisposed) {
			return Observable.empty();
			// ImmutableEmptyObservable<Unit>.Instance
		}
		var subject = collectionReset;
		if (subject == null) {
			subject = collectionReset = new rx.Subject<Unit>();
			// Subject.create<Unit>()
		}
		return subject;
	}

	public function observeAdd():Observable<DictionaryAddEvent<TKey, TValue>> {
		if (isDisposed) {
			return Observable.empty();
			// ImmutableEmptyObservable<DictionaryAddEvent<TKey, TValue>>.Instance
		}
		var subject = dictionaryAdd;
		if (subject == null) {
			subject = dictionaryAdd = new rx.Subject<DictionaryAddEvent<TKey, TValue>>();
			// Subject.create<DictionaryAddEvent<TKey, TValue>>()
		}
		return subject;
	}

	public function observeRemove():Observable<DictionaryRemoveEvent<TKey, TValue>> {
		if (isDisposed) {
			return Observable.empty();
			// ImmutableEmptyObservable<DictionaryRemoveEvent<TKey, TValue>>.Instance
		}
		var subject = dictionaryRemove;
		if (subject == null) {
			subject = dictionaryRemove = new rx.Subject<DictionaryRemoveEvent<TKey, TValue>>();
			// Subject.create<DictionaryRemoveEvent<TKey, TValue>>()
		}
		return subject;
	}

	public function observeReplace():Observable<DictionaryReplaceEvent<TKey, TValue>> {
		if (isDisposed) {
			return Observable.empty();
			// ImmutableEmptyObservable<DictionaryReplaceEvent<TKey, TValue>>.Instance
		}
		var subject = dictionaryReplace;
		if (subject == null) {
			subject = dictionaryReplace = new rx.Subject<DictionaryReplaceEvent<TKey, TValue>>();
			// Subject.create<DictionaryReplaceEvent<TKey, TValue>>()
		}
		return subject;
	}

	// Iterable метод
	public function iterator():Iterator<{key:TKey, value:TValue}> {
		// Создаем итератор, который возвращает объекты {key: TKey, value: TValue}
		var keysArray = [for (k in inner.keys()) k];
		var index = 0;
		return {hasNext: function() return index < keysArray.length, next: function() {
			var key = keysArray[index];
			var value = inner.get(key);
			index++;
			return {key: key, value: value};
		}};
	}

	// IDisposable метод
	public function dispose():Void {
		disposeInternal(true);
	}

	// Методы для получения Enumerator (в Haxe это iterator)
	public function getEnumerator():Iterator<{key:TKey, value:TValue}> {
		return iterator();
	}

	// Вспомогательные методы для освобождения ресурсов
	function disposeSubject<TSubject>(subject:Subject<TSubject>):Void {
		if (subject == null) {
			return;
		}
		try {
			subject.on_completed();
			// Используем правильное имя метода
		}
		finally
		{
			// Subject в RxHaxe может не иметь dispose(), или он может быть в ISubscription
			// Предположим, что Subject сам управляет ресурсами или unsubscribe() достаточно
			// subject.dispose();
			// Закомментировано, так как может не существовать
		}
	}

	function disposeInternal(disposing:Bool):Void {
		if (isDisposed) {
			return;
		}
		if (disposing) {
			disposeSubject(countChanged);
			countChanged = null;
			disposeSubject(collectionReset);
			collectionReset = null;
			disposeSubject(dictionaryAdd);
			dictionaryAdd = null;
			disposeSubject(dictionaryRemove);
			dictionaryRemove = null;
			disposeSubject(dictionaryReplace);
			dictionaryReplace = null;
		}
		isDisposed = true;
		inner = null;
		// Освобождаем ссылку на Map
	}
	#else
	// Заглушка для платформ без поддержки
	public var count(get, null):Int;

	function get_count():Int
		return 0;

	public var keys(get, null):Iterable<TKey>;

	function get_keys():Iterable<TKey>
		return [];

	public var values(get, null):Iterable<TValue>;

	function get_values():Iterable<TValue>
		return [];

	public function new(?comparer:TKey->TKey->Int) {}

	public function fromMap(innerMap:Dynamic) {}

	public function get(key:TKey):TValue
		return cast null;

	public function set(key:TKey, value:TValue):TValue
		return value;

	public function add(key:TKey, value:TValue):Void {}

	public function clear():Void {}

	public function remove(key:TKey):Bool
		return false;

	public function containsKey(key:TKey):Bool
		return false;

	public function tryGetValue(key:TKey, value:Dynamic):Bool
		return false;

	public function observeCountChanged():rx.Observable<Int> {
		return null;
	}

	public function observeReset():rx.Observable<systemsrx.computeds.Unit> {
		return null;
	}

	public function observeAdd():rx.Observable<DictionaryAddEvent<TKey, TValue>> {
		return null;
	}

	public function observeRemove():rx.Observable<DictionaryRemoveEvent<TKey, TValue>> {
		return null;
	}

	public function observeReplace():rx.Observable<DictionaryReplaceEvent<TKey, TValue>> {
		return null;
	}

	public function iterator():Iterator<{key:TKey, value:TValue}> {
		return [].iterator();
	}

	public function getEnumerator():Iterator<{key:TKey, value:TValue}> {
		return iterator();
	}

	public function dispose():Void {}

	function disposeSubject<TSubject>(subject:Dynamic):Void {}

	function disposeInternal(disposing:Bool):Void {}
	#end
}

// Вспомогательный класс для передачи ссылки на значение в tryGetValue
class Ref<T> {
	public var value:T;

	public function new(?value:T) {
		this.value = value;
	}
}