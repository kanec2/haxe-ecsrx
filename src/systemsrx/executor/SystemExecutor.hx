package systemsrx.executor;

import systemsrx.systems.ISystem;
import systemsrx.executor.handlers.IConventionalSystemHandler;
import systemsrx.exceptions.SystemAlreadyRegisteredException;
import hx.concurrent.lock.Semaphore;

class SystemExecutor implements ISystemExecutor {
	public var systems:Array<ISystem>;

	var conventionalSystemHandlers:Array<IConventionalSystemHandler>;
	var semaphore:Semaphore;

	public function new(conventionalSystemHandlers:Array<IConventionalSystemHandler>) {
		this.conventionalSystemHandlers = conventionalSystemHandlers;
		systems = [];
		semaphore = new Semaphore(1);
		// Binary semaphore for mutual exclusion
	}

	public function hasSystem(system:ISystem):Bool {
		semaphore.acquire();
		var result = systems.indexOf(system) != -1;
		semaphore.release();
		return result;
	}

	public function removeSystem(system:ISystem):Void {
		semaphore.acquire();
		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;
		var applicableHandlers = getHandlersForSystem(system);
		for (handler in applicableHandlers) {
			try {
				handler.destroySystem(system);
			} catch (e:Dynamic) {
				// Сохраняем информацию об ошибке, но продолжаем выполнение
				// чтобы освободить семафор. Ошибка будет проброшена позже.
				if (!hasError) { // Сохраняем первую ошибку
					hasError = true;
					errorValue = e;
				}
			}
		}
		systems.remove(system);
		semaphore.release();

		// Если была ошибка, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}
	}

	public function addSystem(system:ISystem):Void {
		semaphore.acquire();
		// Вручную проверяем наличие системы, чтобы избежать двойного захвата семафора
		var isAlreadyRegistered = systems.indexOf(system) != -1;
		if (isAlreadyRegistered) {
			semaphore.release();
			throw new SystemAlreadyRegisteredException("System already registered");
		}

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;
		var applicableHandlers = getHandlersForSystem(system);
		for (handler in applicableHandlers) {
			try {
				handler.setupSystem(system);
			} catch (e:Dynamic) {
				// Сохраняем информацию об ошибке, но продолжаем выполнение
				// чтобы освободить семафор и удалить частично добавленную систему.
				if (!hasError) { // Сохраняем первую ошибку
					hasError = true;
					errorValue = e;
				}
			}
		}
		if (!hasError) {
			systems.push(system);
		} else {
			// Если была ошибка при настройке, удаляем систему из списка (на всякий случай)
			// Хотя она туда еще не была добавлена, это защита от непредвиденных ситуаций
			systems.remove(system);
		}
		semaphore.release();

		// Если была ошибка, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}
	}

	function getHandlersForSystem(system:ISystem):Array<IConventionalSystemHandler> {
		var applicableHandlers = [];
		for (handler in conventionalSystemHandlers) {
			if (handler.canHandleSystem(system)) {
				applicableHandlers.push(handler);
			}
		}
		// TODO: Sort by priority
		return applicableHandlers;
	}

	public function dispose():Void {
		semaphore.acquire();
		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;
		// Remove systems in reverse order
		// Create a copy to avoid modification during iteration
		var systemsCopy = systems.copy();
		for (i in 0...systemsCopy.length) {
			var index = systemsCopy.length - 1 - i;
			if (index < systemsCopy.length) {
				try {
					removeSystem(systemsCopy[index]);
				} catch (e:Dynamic) {
					// Сохраняем информацию об ошибке, но продолжаем выполнение
					// чтобы освободить семафор. Ошибка будет проброшена позже.
					if (!hasError) { // Сохраняем первую ошибку
						hasError = true;
						errorValue = e;
					}
				}
			}
		}
		systems = [];
		semaphore.release();

		// Если была ошибка, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}
	}
}