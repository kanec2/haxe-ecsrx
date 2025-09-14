package systemsrx.executor.handlers.conventional;

#if (concurrent || sys)
import rx.disposables.ISubscription;
import rx.disposables.CompositeDisposable;
import systemsrx.systems.ISystem;
import systemsrx.systems.conventional.IReactiveSystem;
// Предполагаем, что IReactiveSystem<T> существует
// import systemsrx.systems.conventional.IReactiveSystem;
#end

/** * Handler for reactive systems (IReactiveSystem<T>). * Subscribes to the system's reactive stream and passes data to the execute method. * Note: Runtime generic method invocation like in C# is not directly possible in Haxe. * This implementation might require adjustments based on how IReactiveSystem is defined. */
@:priority(6)
// Устанавливаем приоритет, как в C#
class ReactiveSystemHandler implements IConventionalSystemHandler {
	#if (concurrent || sys)
	// public final setupSystemGenericMethodInfo:Dynamic;
	// Заглушка для рефлексии
	// Используем CompositeDisposable для управления несколькими подписками на систему
	public final systemSubscriptions:Map<ISystem, CompositeDisposable>;

	public function new() {
		this.systemSubscriptions = new Map<ISystem, CompositeDisposable>();
		// this.setupSystemGenericMethodInfo = null;
		// Не используется в Haxe
	}

	public function canHandleSystem(system:ISystem):Bool {
		// Предполагаем, что есть способ проверить, является ли система IReactiveSystem
		// return system.isReactiveSystem();
		// Предполагаемый метод
		// Или проверка через Std.is для известных интерфейсов
		return Reflect.hasField(system, "reactTo") && Reflect.hasField(system, "execute");
		// Нужно уточнить интерфейс
	}

	// Предполагаемые вспомогательные методы (могут быть реализованы по-другому)

	/*
		public function getMatchingInterfaces(system:ISystem):Array<Class<Dynamic>> { 
		//Логика для получения интерфейсов, соответствующих IReactiveSystem<T> return []; 
		//Заглушка } */
	public function setupSystem(system:ISystem):Void {
		// Логика аналогична ReactToEventSystemHandler
		var disposables:Array<ISubscription> = [];
		var compositeDisposable = CompositeDisposable.create(disposables);
		systemSubscriptions.set(system, compositeDisposable);
		// Здесь должна быть логика подписки.
		// Пока оставим пустой compositeDisposable
	}

	/*
		public function setupSystemGeneric<T>(system:systemsrx.systems.conventional.IReactiveSystem<T>):ISubscription { 
		//В C#: return system.ReactTo().Subscribe(system.Execute); 
		//В Haxe: 
		//return system.reactTo().subscribe(system.execute); 
		//Нужно уточнить сигнатуры return null; 
		//Заглушка } 
	 */
	public function destroySystem(system:ISystem):Void {
		// Получаем и удаляем CompositeDisposable, если он существует
		if (systemSubscriptions.exists(system)) {
			var compositeDisposable = systemSubscriptions.get(system);
			if (compositeDisposable != null) {
				compositeDisposable.unsubscribe();
				// Отписываемся от всех подписок
			}
			systemSubscriptions.remove(system);
			// Удаляем из карты
		}
	}

	public function dispose():Void {
		// Отписываемся от всех систем
		for (compositeDisposable in systemSubscriptions) {
			if (compositeDisposable != null) {
				compositeDisposable.unsubscribe();
			}
		}
		systemSubscriptions.clear();
		// Очищаем карту
	}
	#else
	// Заглушка для платформ без поддержки
	public function new() {}

	public function canHandleSystem(system:ISystem):Bool
		return false;

	public function setupSystem(system:ISystem):Void {}

	public function destroySystem(system:ISystem):Void {}

	public function dispose():Void {}
	#end
}