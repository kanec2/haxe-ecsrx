package tests.systemsrx.handlers;

import systemsrx.executor.handlers.IConventionalSystemHandler;
import systemsrx.systems.ISystem;

/** 
 * Test handler with lower priority, adapted from SystemsRx.Tests.Systems.Handlers 
 */
@:priority(-10) // Low priority
class LowerPriorityHandler implements IConventionalSystemHandler {
	private var doSomethingOnSetup:Void->Void = null;
	private var doSomethingOnDestroy:Void->Void = null;

	public function new(doSomethingOnSetup:Void->Void = null, doSomethingOnDestroy:Void->Void = null) {
		this.doSomethingOnSetup = doSomethingOnSetup;
		this.doSomethingOnDestroy = doSomethingOnDestroy;
	}

	public function canHandleSystem(system:ISystem):Bool {
		return true;
	}

	public function setupSystem(system:ISystem):Void {
		if (doSomethingOnSetup != null) {
			doSomethingOnSetup();
		}
	}

	public function destroySystem(system:ISystem):Void {
		if (doSomethingOnDestroy != null) {
			doSomethingOnDestroy();
		}
	}

	public function dispose():Void {
		// Фиктивная реализация
	}
}