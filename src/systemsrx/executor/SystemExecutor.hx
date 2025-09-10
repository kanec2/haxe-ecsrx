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
		try {
			var applicableHandlers = getHandlersForSystem(system);
			for (handler in applicableHandlers) {
				handler.destroySystem(system);
			}
			systems.remove(system);
		}
		finally
		{
			semaphore.release();
		}
	}

	public function addSystem(system:ISystem):Void {
		semaphore.acquire();
		try {
			if (hasSystem(system)) {
				throw new SystemAlreadyRegisteredException("System already registered");
			}
			var applicableHandlers = getHandlersForSystem(system);
			for (handler in applicableHandlers) {
				handler.setupSystem(system);
			}
			systems.push(system);
		}
		finally
		{
			semaphore.release();
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
		try {
			// Remove systems in reverse order
			for (i in 0...systems.length) {
				var index = systems.length - 1 - i;
				if (index < systems.length) {
					removeSystem(systems[index]);
				}
			}
			systems = [];
		}
		finally
		{
			semaphore.release();
		}
	}
}