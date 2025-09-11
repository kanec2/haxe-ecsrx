package tests.systemsrx.executor; 
import systemsrx.executor.handlers.IConventionalSystemHandler; 
import systemsrx.systems.ISystem;
class FakeSystemHandler implements IConventionalSystemHandler {
    public var canHandleResult:Bool = false;
    public var setupSystemCalled:Bool = false;
    public var destroySystemCalled:Bool = false;
    public var systemPassedToSetup:ISystem = null;
    public var systemPassedToDestroy:ISystem = null;

    public function new(canHandle:Bool = true) {
        this.canHandleResult = canHandle;
    }

    public function canHandleSystem(system:ISystem):Bool {
        return canHandleResult;
    }

    public function setupSystem(system:ISystem):Void {
        setupSystemCalled = true;
        systemPassedToSetup = system;
    }

    public function destroySystem(system:ISystem):Void {
        destroySystemCalled = true;
        systemPassedToDestroy = system;
    }

    public function dispose():Void {
        // Фиктивная реализация
    }
}