package tests.systemsrx.plugins.computeds;

import utest.Assert;
import utest.Test;
import systemsrx.computeds.data.ComputedFromData;
import systemsrx.computeds.Unit;
import rx.Subject;
import rx.Observable;

class TestComputedFromData extends ComputedFromData<Int, DummyData> {
	public var manuallyRefresh:Subject<Unit>;

	public function new(data:DummyData) {
		// Создаем Subject ДО вызова super()
		this.manuallyRefresh = new rx.Subject<Unit>(); // Subject.create<Unit>()
		super(data);
		// monitorChanges() будет вызван в конструкторе родителя
	}

	public function refreshWhen():Observable<Unit> {
		// Возвращаем созданный Subject
		return manuallyRefresh;
	}

	public function transform(data:DummyData):Int {
		return data.data;
	}
}