package systemsrx.executor.handlers.conventional;

import systemsrx.systems.ISystem;
import systemsrx.systems.conventional.IManualSystem;

// Для приоритета
// import systemsrx.utils.PriorityUtils;
// Если будет использоваться макрос

/** * Handler for IManualSystem. * Calls StartSystem when setting up and StopSystem when destroying. */
@:priority(5)
// Устанавливаем приоритет, как в C#
class ManualSystemHandler implements IConventionalSystemHandler {
	public function new() {
		// Нет зависимостей
	}

	public function canHandleSystem(system:ISystem):Bool {
		return Std.is(system, IManualSystem);
	}

	public function setupSystem(system:ISystem):Void {
		if (Std.is(system, IManualSystem)) {
			var castSystem:IManualSystem = cast system;
			castSystem.startSystem();
			// Вызываем StartSystem
		}
	}

	public function destroySystem(system:ISystem):Void {
		if (Std.is(system, IManualSystem)) {
			var castSystem:IManualSystem = cast system;
			castSystem.stopSystem();
			// Вызываем StopSystem
		}
	}

	public function dispose():Void {
		// Нет ресурсов для освобождения
	}
}