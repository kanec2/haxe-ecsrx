package tests.systemsrx;

import utest.Assert;
import utest.Test;
import systemsrx.reactivedata.ReactiveProperty;
import systemsrx.reactivedata.collections.ReactiveCollection;

// import rx.Observable; // Если будут использоваться Observable

/** 
 * Sanity tests, adapted from SystemsRx.Tests.Sanity 
 */
class SanityTests extends Test {
	public function test_should_notify_and_update_values_with_reactive_property() {
		var reactiveProperty = new ReactiveProperty<Int>(10);
		Assert.equals(10, reactiveProperty.value);

		var timesEntered = 0;
		var sub = reactiveProperty.subscribe(function(x:Int) {
			if (timesEntered == 0) {
				Assert.equals(10, x);
			}
			if (timesEntered == 1) {
				Assert.equals(7, x);
			}
			timesEntered++;
		});
		reactiveProperty.value = 7;
		Assert.equals(7, reactiveProperty.value);
		Assert.equals(2, timesEntered);

		sub.dispose();
	}
	// Добавьте другие тесты по аналогии...
	// Обратите внимание, что некоторые тесты требуют доработки ReactiveProperty и ReactiveCollection
	// или использования RxHaxe Observable.
}