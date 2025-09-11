package tests.systemsrx.plugins.computeds;

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