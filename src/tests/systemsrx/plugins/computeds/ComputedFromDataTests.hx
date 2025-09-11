package tests.systemsrx.computeds;

import utest.Assert;
import utest.Test;
import systemsrx.computeds.data.ComputedFromData;
import systemsrx.computeds.Unit;
import rx.Subject; // Предполагаем, что Subject доступен из RxHaxe

/** 
 * Tests for ComputedFromData, adapted from SystemsRx.Tests.Plugins.Computeds 
 */
class ComputedFromDataTests extends Test {
	// Вспомогательные классы для тестов
	class DummyData {
		public var data:Int;

		public function new(data:Int) {
			this.data = data;
		}
	}
	class TestComputedFromData extends ComputedFromData<Int, DummyData> {
		public var manuallyRefresh:Subject<Unit>;

		public function new(data:DummyData) {
			super(data);
			this.manuallyRefresh = new rx.Subject<Unit>(); // Subject.create<Unit>()
		}

		override public function refreshWhen():rx.Observable<Unit> {
			return manuallyRefresh;
		}

		override public function transform(data:DummyData):Int {
			return data.data;
		}
	}
	public function test_should_populate_on_creation() {
		var expectedData = 10;
		var data = new DummyData(expectedData);

		var computedData = new TestComputedFromData(data);
		Assert.equals(expectedData, computedData.cachedData);
	}

	public function test_should_refresh_value_when_changed_and_value_requested() {
		var expectedData = 20;
		var data = new DummyData(10);

		var computedData = new TestComputedFromData(data);

		data.data = expectedData;
		computedData.manuallyRefresh.on_next(Unit.instance);

		var actualData = computedData.value;
		Assert.equals(expectedData, actualData);
	}

	// Добавьте другие тесты по аналогии...
}