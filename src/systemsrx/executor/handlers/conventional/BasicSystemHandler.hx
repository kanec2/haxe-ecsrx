package systemsrx.executor.handlers.conventional;

#if (concurrent || sys)
import rx.Observable;
import rx.Observer; // Добавить импорт
import rx.disposables.ISubscription;
import systemsrx.scheduling.IUpdateScheduler;
import systemsrx.systems.ISystem;
import systemsrx.systems.conventional.IBasicSystem;
import systemsrx.scheduling.ElapsedTime; // Вместо неправильного пути
// Для приоритета
// import systemsrx.utils.PriorityUtils;
// Если будет использоваться макрос
#end 
/** * Handler for IBasicSystem. 
 * * Subscribes the system's Execute method to the UpdateScheduler's OnUpdate event. 
 * */ 
 //@:priority(6)
// Устанавливаем приоритет, как в C#
class BasicSystemHandler implements IConventionalSystemHandler {
	#if (concurrent || sys)
	public final updateScheduler:IUpdateScheduler;
	// Используем Map из Haxe и ISubscription из RxHaxe
	public final systemSubscriptions:Map<ISystem, ISubscription>;

	public function new(updateScheduler:IUpdateScheduler) {
		this.updateScheduler = updateScheduler;
		this.systemSubscriptions = new Map<ISystem, ISubscription>();
	}

	public function canHandleSystem(system:ISystem):Bool {
		return Std.is(system, IBasicSystem);
	}

	public function setupSystem(system:ISystem):Void {
		if (Std.is(system, IBasicSystem)) {
			var basicSystem:IBasicSystem = cast system;
			// Подписываемся на onUpdate и вызываем execute у системы
			// В RxHaxe subscribe возвращает ISubscription
			var subscription = updateScheduler.onUpdate.subscribe(Observer.create( 
				function():Void {}, // onCompleted 
				function(error:String):Void {}, // onError 
				function(elapsedTime:ElapsedTime):Void { // onNext 
				basicSystem.execute(elapsedTime); 
				} 
			));
			systemSubscriptions.set(system, subscription);
		}
	}

	public function destroySystem(system:ISystem):Void {
		// Получаем и удаляем подписку, если она существует
		if (systemSubscriptions.exists(system)) {
			var subscription = systemSubscriptions.get(system);
			if (subscription != null) {
				subscription.unsubscribe();
				// Отписываемся
			}
			systemSubscriptions.remove(system);
			// Удаляем из карты
		}
		// В C# был метод RemoveAndDispose, который, вероятно, удалял из словаря и вызывал Dispose
		// В Haxe/RxHaxe ISubscription имеет метод unsubscribe()
	}

	public function dispose():Void {
		// Отписываемся от всех систем
		for (subscription in systemSubscriptions) {
			if (subscription != null) {
				subscription.unsubscribe();
			}
		}
		systemSubscriptions.clear();
		// Очищаем карту
	}
	#else
	// Заглушка для платформ без поддержки
	public function new(updateScheduler:Dynamic) {}

	public function canHandleSystem(system:ISystem):Bool
		return false;

	public function setupSystem(system:ISystem):Void {}

	public function destroySystem(system:ISystem):Void {}

	public function dispose():Void {}
	#end
}