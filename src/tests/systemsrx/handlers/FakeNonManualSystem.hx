package tests.systemsrx.handlers;

import utest.Assert;
import utest.Test;
import systemsrx.executor.handlers.conventional.ManualSystemHandler;
import systemsrx.systems.conventional.IManualSystem;
import systemsrx.systems.ISystem;

class FakeNonManualSystem implements ISystem {
    public function new() {}
}