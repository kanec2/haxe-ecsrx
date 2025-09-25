package tests.systemsrx.plugins.computeds;

import utest.Assert;
import utest.Test;
import systemsrx.computeds.data.ComputedFromData;
import systemsrx.computeds.Unit;
import rx.Observable;
import rx.Subject;
import tests.mocks.*;

class ComputedFromDataAdditionalTests extends Test {
	public function test_should_handle_transform_error() {
		var dataSource = new FaultyDataSource(10);
		var computedData = new FaultyTransformComputedFromData(dataSource);
		// ИСПРАВЛЕНИЕ: Устанавливаем флаг ДО вызова value/getData()
		computedData.shouldThrowOnTransform = true;

		try {
			// Вызываем getData()/value, который должен бросить исключение из transform()
			var value = computedData.value;
			Assert.fail("Should have thrown an exception");
		} catch (e:Dynamic) {
			// Ожидаем исключение
			Assert.equals("Transform error", e);
		}
	}

	public function test_should_handle_refresh_when_error() {
		var dataSource = new FaultyDataSource(10);
		var computedData = new FaultyRefreshWhenComputedFromData(dataSource);
		// ИСПРАВЛЕНИЕ: Устанавливаем флаг ДО вызова requestUpdate()
		computedData.shouldThrowOnRefreshWhen = true;

		try {
			// Вызываем requestUpdate(), который должен бросить исключение из refreshWhen()
			computedData.requestUpdate();
			Assert.fail("Should have thrown an exception");
		} catch (e:Dynamic) {
			// Ожидаем исключение
			Assert.equals("RefreshWhen error", e);
		}
	}
}
