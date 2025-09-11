package tests.systemsrx.sanity;

import utest.Assert;
import utest.Test;
import systemsrx.reactivedata.ReactiveProperty;
import systemsrx.reactivedata.collections.ReactiveCollection;
import rx.Observer; // Для Observer.create

// import rx.Observable; // Если будут использоваться Observable

/** 
 * Sanity tests, adapted from SystemsRx.Tests.Sanity 
 */
class SanityTests extends Test {
	public function test_should_notify_and_update_values_with_reactive_property() {
		var reactiveProperty = new ReactiveProperty<Int>(10);
		Assert.equals(10, reactiveProperty.value);

		var timesEntered = 0;
		// ИСПРАВЛЕНИЕ: Используем Observer.create для создания IObserver из функций
		var sub = reactiveProperty.subscribe(Observer.create( // onCompleted
			function():Void {
				// В данном случае ничего не делаем при завершении
			}, // onError
			function(error:String):Void {
				// Обрабатываем ошибку, если она возникнет
				trace("Error in reactiveProperty subscription: " + error);
			}, // onNext
			function(x:Int):Void {
				if (timesEntered == 0) {
					Assert.equals(10, x);
				}
				if (timesEntered == 1) {
					Assert.equals(7, x);
				}
				timesEntered++;
			}));
		reactiveProperty.value = 7;
		Assert.equals(7, reactiveProperty.value);
		Assert.equals(2, timesEntered);

		sub.unsubscribe();
	}
	// Добавьте другие тесты по аналогии...
	// Обратите внимание, что некоторые тесты требуют доработки ReactiveProperty и ReactiveCollection
	// или использования RxHaxe Observable.
}