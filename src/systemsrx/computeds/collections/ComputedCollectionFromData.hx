package systemsrx.computeds.collections; #if (concurrent || sys) import rx.Observable;

import rx.Subject;
import rx.disposables.ISubscription;
import rx.observers.IObserver;
import haxe.concurrent.lock.Semaphore;
// Для синхронизации
#end import systemsrx.computeds.Unit; /** * Abstract base class for a computed collection that is derived from a data source. * @typeparam TInput The type of the data source. * @typeparam TOutput The type of elements in the computed collection. */ class ComputedCollectionFromData<TInput,
	TOutput> implements IComputedCollection<TOutput> /*implements IDisposable*/ {

	#if (concurrent || sys)
	public var computedData:Array<TOutput>;
	public var subscriptions:Array<ISubscription>;
	public var dataSource(default, null):TInput;
	// Реализация IComputed<Iterable<TOutput>>
	public var value(get, null):Iterable<TOutput>;

	function get_value():Iterable<TOutput> {
		return getData();
	}

	public function get(index:Int):TOutput {
		return computedData[index];
	}

	public var count(get, null):Int;

	function get_count():Int {
		return computedData.length;
	}

	final onDataChanged:Subject<Iterable<TOutput>>;
	var needsUpdate:Bool;
	final lock:Semaphore;

	// Используем Semaphore как Mutex
	public function new(dataSource:TInput) {
		this.dataSource = dataSource;
		this.subscriptions = [];
		this.computedData = [];
		this.onDataChanged = new rx.Subject<Iterable<TOutput>>();
		// Subject.create<Iterable<TOutput>>()
		this.needsUpdate = true;
		// Нужно обновить при первом запросе значения
		this.lock = new Semaphore(1, 1);
		// Бинарный семафор для взаимного исключения monitorChanges();
		// refreshData();
		// Не вызываем сразу
	}

	// Реализация Observable<Iterable<TOutput>>
	public function subscribe(observer:IObserver<Iterable<TOutput>>):ISubscription {
		return onDataChanged.subscribe(observer);
	}

	public function monitorChanges():Void {
		// Подписываемся на сигнал обновления и вызываем requestUpdate
		var subscription:ISubscription = refreshWhen().subscribe(function(b:Bool) {
			requestUpdate();
		});
		subscriptions.push(subscription);
	}

	public function requestUpdate(?_:Dynamic):Void {
		needsUpdate = true;
		// Если есть подписчики на onDataChanged, обновляем данные немедленно
		// if (onDataChanged.hasObservers()) { refreshData();
		// }
	}

	public function refreshData():Void {
		lock.acquire();
		try {
			transform(dataSource);
			needsUpdate = false;
		}
		finally
		{
			lock.release();
		}
		// Уведомляем подписчиков о новом значении
		onDataChanged.on_next(computedData);
	} /** * The method to indicate when the collection should be updated. * @return An observable trigger that should trigger when the collection should refresh. */ public abstract function refreshWhen():Observable<Bool>; /** * The method to populate computedData from the data source. * @param dataSource The dataSource to transform. */ public abstract function transform(dataSource:TInput):Void;

	public function getData():Iterable<TOutput> {
		if (needsUpdate) {
			refreshData();
		}
		return computedData;
	}

	// Реализация Iterable<TOutput>
	public function iterator():Iterator<TOutput> {
		return getData().iterator();
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
		computedData.resize(0);
		// Очищаем данные
		// Отписываем и уничтожаем Subject
		if (onDataChanged != null) {
			onDataChanged.on_completed();
			// onDataChanged = null;
			// Нельзя присвоить null final полю
		}
	}
	#else
	// Заглушка для платформ без поддержки
	public var computedData:Array<TOutput>;
	public var dataSource(default, null):TInput;
	public var value(get, null):Iterable<TOutput>;

	function get_value():Iterable<TOutput>
		return [];

	public function get(index:Int):TOutput
		return cast null;

	public var count(get, null):Int;

	function get_count():Int
		return 0;

	public function new(dataSource:TInput) {
		this.dataSource = dataSource;
	}

	public function subscribe(observer:rx.observers.IObserver<Iterable<TOutput>>):rx.disposables.ISubscription {
		return null;
	}

	public function monitorChanges():Void {}

	public function requestUpdate(?_:Dynamic):Void {}

	public function refreshData():Void {}

	public abstract function refreshWhen():rx.Observable<Bool>;

	public abstract function transform(dataSource:TInput):Void;

	public function getData():Iterable<TOutput>
		return [];

	public function iterator():Iterator<TOutput>
		return [].iterator();

	public function dispose():Void {}
	#end
}