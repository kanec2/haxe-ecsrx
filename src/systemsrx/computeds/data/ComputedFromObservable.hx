package systemsrx.computeds.data;

#if (threads || sys)
import rx.Observable;
import rx.Subject;
import rx.disposables.ISubscription;
import rx.observers.IObserver;
import haxe.concurrent.lock.Semaphore;
// Для синхронизации
#end import systemsrx.computeds.IComputed; /** * Abstract base class for a computed value that is derived from an observable data source. * The computation is triggered whenever the observable emits a new value. * @typeparam TOutput The type of the computed value. * @typeparam TInput The type of the data emitted by the observable source. */ class ComputedFromObservable<TOutput,
	TInput> implements IComputed<TOutput> /*implements IDisposable*/ {

	#if (threads || sys)
	public var cachedData:TOutput;

	final subscriptions:Array<ISubscription>;
	final onDataChanged:Subject<TOutput>;
	final lock:Semaphore;

	// Используем Semaphore как Mutex
	public var dataSource(default, null):Observable<TInput>;

	public function new(dataSource:Observable<TInput>, ?initialValue:TOutput) {
		this.dataSource = dataSource;
		this.cachedData = initialValue;
		this.subscriptions = [];
		this.onDataChanged = new rx.Subject<TOutput>();
		// Subject.create<TOutput>()
		this.lock = new Semaphore(1, 1);
		// Бинарный семафор для взаимного исключения
		monitorChanges();
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
		// Подписываемся на источник данных и вызываем refreshData при получении нового значения
		var subscription:ISubscription = dataSource.subscribe(function(data:TInput) {
			refreshData(data);
		});
		subscriptions.push(subscription);
	}

	public function refreshData(data:TInput):Void {
		lock.acquire();
		try {
			cachedData = transform(data);
		}
		finally
		{
			lock.release();
		}
		// Уведомляем подписчиков о новом значении
		onDataChanged.on_next(cachedData);
	} /** * The method to generate the computed value from the data emitted by the source. * @param dataSource The data emitted by the source. * @return The transformed data. */ public abstract function transform(data:TInput):TOutput;

	public function getData():TOutput {
		return cachedData;
	}

	public function dispose():Void {
		// Отписываемся от всех подписок
		for (subscription in subscriptions) {
			if (subscription != null) {
				subscription.unsubscribe();
			}
		}
		subscriptions.resize(0);
		// Очищаем массив
		// Отписываем и уничтожаем Subject
		if (onDataChanged != null) {
			onDataChanged.on_completed();
			// onDataChanged = null;
			// Нельзя присвоить null final полю
		}
	}
	#else
	// Заглушка для платформ без поддержки
	public var cachedData:TOutput;
	public var dataSource(default, null):rx.Observable<TInput>;
	public var value(get, null):TOutput;

	function get_value():TOutput
		return cast null;

	public function new(dataSource:rx.Observable<TInput>, ?initialValue:TOutput) {
		this.dataSource = dataSource;
	}

	public function subscribe(observer:rx.observers.IObserver<TOutput>):rx.disposables.ISubscription {
		return null;
	}

	public function monitorChanges():Void {}

	public function refreshData(data:TInput):Void {}

	public abstract function transform(data:TInput):TOutput;

	public function getData():TOutput
		return cast null;

	public function dispose():Void {}
	#end
}