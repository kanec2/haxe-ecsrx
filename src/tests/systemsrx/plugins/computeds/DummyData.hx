package tests.systemsrx.plugins.computeds;

import utest.Assert;
import utest.Test;
import systemsrx.computeds.data.ComputedFromData;
import systemsrx.computeds.Unit;
import rx.Subject;

class DummyData {
    public var data:Int;

    public function new(data:Int) {
        this.data = data;
    }
}