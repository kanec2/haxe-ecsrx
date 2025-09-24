package systemsrx.computeds.data;

import rx.disposables.Composite;
import rx.Observer;
#if (threads || sys)
import rx.Observable;
import rx.Subject;
import rx.disposables.ISubscription;
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
@:keep // Чтобы класс не был удален DCE
abstract class ComputedFromData<TOutput, TInput> implements IComputed<TOutput> {
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
		this.needsUpdate = true; // Нужно обновить при первом запросе значения
		// ИСПРАВЛЕНИЕ: Используем правильный конструктор Semaphore
		this.lock = new Semaphore(1); // Бинарный семафор для взаимного исключения (Mutex)

		// ИСПРАВЛЕНИЕ 1: Вызываем MonitorChanges и RefreshData в конструкторе, как в C#
		monitorChanges();
		refreshData(); // Это установит начальное значение cachedData и needsUpdate = false

	}

	public function getData():TOutput {
		#if (threads || sys)

		lock.acquire();
		#end

		// ИСПРАВЛЕНИЕ: Правильная обработка исключений с try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;
		var result:TOutput = null;

		try {
			if (needsUpdate) {
				refreshData(); // Может бросить исключение из transform()
			}
			result = cachedData;
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		// Завершающие действия вне блока try - ОБЯЗАТЕЛЬНО вызываем semaphore.release()
		#if (threads || sys)

		lock.release();
		#end

		// Если была ошибка во время refreshData(), пробрасываем её после освобождения ресурсов
		if (hasError) {
			trace("Throwing error from getData()");
			throw errorValue;
		}

		return result;
	}

	public function monitorChanges():Void {
		// Подписываемся на сигнал обновления и вызываем requestUpdate
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
		subscriptions.push(Composite.create([subscription]));
	}

	public function requestUpdate(?_:Dynamic):Void {
		needsUpdate = true;

		// Проверяем, есть ли подписчики у onDataChanged, как в C#
		// Это делается через вызов refreshWhen() и проверку подписчиков у результата
		try {
			// var refreshObservable = refreshWhen(); // Может бросить исключение
			if (onDataChanged != null && onDataChanged.hasObservers()) {
				// Вызываем refreshData(), который может бросить исключение
				refreshData();
			}
		} catch (e:Dynamic) {
			// Если refreshWhen() или hasObservers() бросили исключение, пробрасываем его
			throw e;
		}
		// Если подписчиков нет, обновление будет отложено до вызова getData()
		// или пока кто-нибудь не подпишется.
	}


		public function refreshData():Void {
			#if (threads || sys)
			// semaphore.acquire(); // Не захватываем семафор, так как он уже захвачен в getData()
			#end

			// ИСПРАВЛЕНИЕ: Правильная обработка исключений с try-finally вручную
			var hasError = false;
			var errorValue:Dynamic = null;

			try {
				// transform() может бросить исключение
				cachedData = transform(dataSource);
				needsUpdate = false;
			} catch (e:Dynamic) {
				// Сохраняем информацию об ошибке
				hasError = true;
				errorValue = e;
			}

			// Завершающие действия вне блока try
			#if (threads || sys)
			// semaphore.release(); // Не освобождаем семафор, так как он будет освобожден в getData()
			#end

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

		// Реализация Observable<TOutput>
		public function subscribe(observer:rx.observers.IObserver<TOutput>):rx.disposables.ISubscription {
			return onDataChanged.subscribe(observer);
		}

		// Реализация IComputed<TOutput>
		public var value(get, null):TOutput;

		function get_value():TOutput {
			return getData();
		}

		public function dispose():Void {
			#if (threads || sys)
			lock.acquire();
			#end

			// ИСПРАВЛЕНИЕ 8: Правильная обработка исключений с try-finally
			var hasError = false;
			var errorValue:Dynamic = null;

			try {
				// Отписываемся от всех подписок
				for (subscription in subscriptions) {
					if (subscription != null) {
						subscription.unsubscribe();
						// Используем правильное имя метода
					}
				}
				subscriptions.resize(0);

				// Отписываем и уничтожаем Subject
				if (onDataChanged != null) {
					onDataChanged.on_completed();
					// Завершаем Subject
					// onDataChanged = null;
					// Нельзя присвоить null final полю
				}
			} catch (e:Dynamic) {
				hasError = true;
				errorValue = e;
			}

			#if (threads || sys)
			lock.release();
			#end

			// Если была ошибка, пробрасываем её после освобождения ресурсов
			if (hasError) {
				throw errorValue;
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
	}

	public function getData():TOutput
		return cast null;

	public function monitorChanges():Void {}

	public function requestUpdate(?_:Dynamic):Void {}

	public function refreshData():Void {}

	public function subscribe(observer:rx.observers.IObserver<TOutput>):rx.disposables.ISubscription {
		return null;
	}

	public abstract function refreshWhen():rx.Observable<systemsrx.computeds.Unit>;

	public abstract function transform(dataSource:TInput):TOutput;

	public function dispose():Void {}
	#end
}