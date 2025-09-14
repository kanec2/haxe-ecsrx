package systemsrx.computeds.data;

#if (threads || sys)
import rx.Observable;
import rx.Observer;
import rx.Subject;
import rx.disposables.ISubscription;
import rx.observers.IObserver;
import hx.concurrent.lock.Semaphore; // Для синхронизации
#end
import systemsrx.computeds.IComputed;
import systemsrx.computeds.Unit;

/** 
 * Abstract base class for a computed value that is derived from a data source. 
 * The computation is triggered by an observable signal. 
 * @typeparam TOutput The type of the computed value. 
 * @typeparam TInput The type of the data source. 
 */
abstract class ComputedFromData<TOutput, TInput> implements IComputed<TOutput> /*implements IDisposable*/ {
	#if (threads || sys)
	public var cachedData:TOutput;

	final subscriptions:Array<ISubscription>;
	final onDataChanged:Subject<TOutput>;
	var needsUpdate:Bool;
	final lock:Semaphore; // Используем Semaphore как Mutex

	public var dataSource(default, null):TInput;

	public function new(dataSource:TInput) {
		this.dataSource = dataSource;
		this.subscriptions = [];
		this.onDataChanged = new rx.Subject<TOutput>(); // Subject.create<TOutput>()
		// ИСПРАВЛЕНИЕ 1: Инициализируем флаг needsUpdate как false, так как RefreshData() вызывается
		this.needsUpdate = false;
		// ИСПРАВЛЕНИЕ 2: Используем правильный конструктор Semaphore
		this.lock = new Semaphore(1); // Бинарный семафор: 1 permit изначально доступен

		// ИСПРАВЛЕНИЕ 3: Вызываем MonitorChanges(), как в C#
		monitorChanges();
		// ИСПРАВЛЕНИЕ 4: Вызываем RefreshData() сразу, как в C#, чтобы инициализировать CachedData
		refreshData(); // Это установит CachedData = Transform(DataSource) и needsUpdate = false
	}

	// Реализация Observable<TOutput>
	public function subscribe(observer:IObserver<TOutput>):ISubscription {
		return onDataChanged.subscribe(observer);
	}

	// Реализация IComputed<TOutput>
	public var value(get, null):TOutput;

	function get_value():TOutput {
		return getData();
	}

	public function monitorChanges():Void {
		// Подписываемся на сигнал обновления и вызываем requestUpdate
		// ИСПРАВЛЕНИЕ: Используем Observer.create для создания IObserver из функций
		var subscription:ISubscription = refreshWhen().subscribe(Observer.create( // onCompleted
			function():Void {
				// В данном случае ничего не делаем при завершении источника
			}, // onError
			function(error:String):Void {
				// Обрабатываем ошибку источника, если необходимо.
				// Для простоты, можно логировать или игнорировать.
				// requestUpdate() не вызываем, так как это не "нормальное" обновление.
				#if debug
				trace("Error in ComputedFromData refreshWhen observable: " + error);
				#end
			}, // onNext
			function(unit:Unit):Void {
				requestUpdate();
			}));
		subscriptions.push(subscription);
	}

	public function requestUpdate(?_:Dynamic):Void {
		needsUpdate = true;
		// ИСПРАВЛЕНИЕ 5: Проверяем, есть ли подписчики на onDataChanged, как в C#
		
		if ( onDataChanged.hasObservers() ) {
			refreshData();
		}
		// Для простоты и соответствия логике "если есть подписчики, обновить немедленно",
		// мы можем вызвать RefreshData() всегда, но это нарушает семантику отложенного обновления.
		// Лучше найти способ проверить наличие подписчиков.
		// Пока что оставим без вызова RefreshData() здесь, как в оригинале,
		// предполагая, что проверка будет реализована позже или иначе.
		// Но в C# коде RefreshData() вызывается только если HasObservers=true.
		// В оригинальном C# коде:
		// if(_onDataChanged.HasObservers)
		// { RefreshData(); }
		// Нам нужно имитировать это поведение.
		// Если в RxHaxe нет прямого эквивалента HasObservers,
		// можно добавить счетчик подписчиков или использовать флаг.
		// Для начала оставим без вызова RefreshData() здесь.
	}

	public function refreshData():Void {
		lock.acquire();
		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;
		try {
			cachedData = transform(dataSource);
			needsUpdate = false;
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}
		// Завершающие действия вне блока try
		lock.release();

		// Если была ошибка, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}

		// Уведомляем подписчиков о новом значении
		// Используем правильное имя метода из RxHaxe Subject
		onDataChanged.on_next(cachedData);
	}

	/** 
	 * The method to indicate when the computation should be updated. 
	 * @return An observable trigger that should trigger when the computation should refresh. 
	 */
	public abstract function refreshWhen():Observable<Unit>;

	/** 
	 * The method to generate the computed value from the data source. 
	 * @param dataSource The source of data to work off. 
	 * @return The transformed data. 
	 */
	public abstract function transform(dataSource:TInput):TOutput;

	public function getData():TOutput {
		if (needsUpdate) {
			refreshData();
		}
		return cachedData;
	}

	public function dispose():Void {
		// Отписываемся от всех подписок
		for (subscription in subscriptions) {
			if (subscription != null) {
				subscription.unsubscribe(); // Используем правильное имя метода
			}
		}
		subscriptions.resize(0); // Очищаем массив

		// Отписываем и уничтожаем Subject
		if (onDataChanged != null) {
			onDataChanged.on_completed(); // Завершаем Subject
			// onDataChanged = null; // Нельзя присвоить null final полю
		}
	}
	#else
	// Заглушка для платформ без поддержки
	public var cachedData:TOutput;
	public var dataSource(default, null):TInput;
	public var value(get, null):TOutput;

	function get_value():TOutput
		return cast null;

	public function new(dataSource:TInput) {
		this.dataSource = dataSource;
		// Инициализация других полей заглушки, если необходимо
		// В данном случае других полей инициализировать не нужно,
		// так как они будут инициализированы при первом доступе
		// или останутся null/default.
	}

	public function subscribe(observer:rx.observers.IObserver<TOutput>):rx.disposables.ISubscription {
		return null;
	}

	public function monitorChanges():Void {}

	public function requestUpdate(?_:Dynamic):Void {}

	public function refreshData():Void {}

	public abstract function refreshWhen():rx.Observable<systemsrx.computeds.Unit>;

	public abstract function transform(dataSource:TInput):TOutput;

	public function getData():TOutput
		return cast null;

	public function dispose():Void {}
	#end
}