package tests.systemsrx.plugins.computeds;

import utest.Assert;
import utest.Test;
import systemsrx.computeds.data.ComputedFromData;
import systemsrx.computeds.Unit;
import rx.Subject; // Предполагаем, что Subject доступен из RxHaxe

class TestComputedFromData extends ComputedFromData<Int, DummyData> {
    public var manuallyRefresh:Subject<Unit>;

    public function new(data:DummyData) {
        super(data);
        this.manuallyRefresh = new rx.Subject<Unit>(); // Subject.create<Unit>()
    }

    public function refreshWhen():rx.Observable<Unit> {
        return manuallyRefresh;
    }

    public function transform(data:DummyData):Int {
        return data.data;
    }
}