package tests.systemsrx.handlers;

import utest.Assert;
import utest.Test;
import systemsrx.executor.handlers.conventional.ManualSystemHandler;
import systemsrx.systems.conventional.IManualSystem;
import systemsrx.systems.ISystem;

class FakeManualSystem implements IManualSystem {
    public var startSystemCalled:Bool = false;
    public var stopSystemCalled:Bool = false;

    public function new() {}

    public function startSystem():Void {
        startSystemCalled = true;
    }

    public function stopSystem():Void {
        stopSystemCalled = true;
    }
}