package systemsrx.executor.handlers.conventional;

#if (threads || sys)
import rx.Observable;
import rx.Observer;
import rx.disposables.ISubscription;
import rx.disposables.CompositeDisposable;
import systemsrx.systems.ISystem;
import systemsrx.systems.conventional.IReactiveSystem;
import hx.concurrent.lock.Semaphore; // Для синхронизации

#end

/** 
 * Handler for reactive systems (IReactiveSystem<T>). 
 * Subscribes to the system's reactive stream and passes data to the execute method. 
 */
@:priority(6)
class ReactiveSystemHandler implements IConventionalSystemHandler {
	#if (threads || sys)
	// Добавляем недостающий семафор для взаимного исключения (Mutex)
	final semaphore:Semaphore;

	public final systemSubscriptions:Map<ISystem, ISubscription>;
	#end

	public function new() {
		#if (threads || sys)
		// Бинарный семафор для взаимного исключения (Mutex)
		semaphore = new Semaphore(1);
		systemSubscriptions = new Map<ISystem, ISubscription>();
		#end
	}

	public function canHandleSystem(system:ISystem):Bool {
		#if (threads || sys)
		return Std.is(system, IReactiveSystem);
		#else
		return false;
		#end
	}

	public function setupSystem(system:ISystem):Void {
		#if (threads || sys)
		semaphore.acquire();
		#end

		try {
			if (Std.is(system, IReactiveSystem)) {
				var castSystem:IReactiveSystem<Dynamic> = cast system;
				// Подписываемся на реактивный поток данных системы и вызываем execute при получении данных
				var subscription:ISubscription = castSystem.reactTo().subscribe(Observer.create( // onCompleted
					function():Void {
						// В данном случае ничего не делаем при завершении источника
					}, // onError
					function(error:String):Void {
						// Обрабатываем ошибку источника, если необходимо
						#if debug
						trace("Error in ReactiveSystemHandler: " + error);
						#end
					}, // onNext
					function(data:Dynamic):Void {
						// Вызываем execute у системы с полученными данными
						castSystem.execute(data);
					}));
				systemSubscriptions.set(system, CompositeDisposable.create([subscription]));
			}
		} catch (e:Dynamic) {
			#if (threads || sys)
			semaphore.release();
			#end
			throw e;
		}

		#if (threads || sys)
		semaphore.release();
		#end
	}

	public function destroySystem(system:ISystem):Void {
		#if (threads || sys)
		semaphore.acquire();
		#end

		try {
			// Получаем и удаляем подписку, если она существует
			if (systemSubscriptions.exists(system)) {
				var subscription = systemSubscriptions.get(system);
				if (subscription != null) {
					subscription.unsubscribe();
				}
				systemSubscriptions.remove(system);
			}
		} catch (e:Dynamic) {
			#if (threads || sys)
			semaphore.release();
			#end
			throw e;
		}

		#if (threads || sys)
		semaphore.release();
		#end
	}

	public function dispose():Void {
		#if (threads || sys)
		semaphore.acquire();
		#end

		try {
			// Отписываемся от всех систем
			for (subscription in systemSubscriptions) {
				if (subscription != null) {
					subscription.unsubscribe();
				}
			}
			systemSubscriptions.clear();
		} catch (e:Dynamic) {
			#if (threads || sys)
			semaphore.release();
			#end
			throw e;
		}

		#if (threads || sys)
		semaphore.release();
		#end
	}
}