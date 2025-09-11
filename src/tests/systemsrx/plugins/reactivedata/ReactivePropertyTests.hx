package tests.systemsrx.plugins.reactivedata;

import utest.Assert;
import utest.Test;
import systemsrx.reactivedata.ReactiveProperty;

// import rx.Subject; // Если будут использоваться Subject

/** 
 * Tests for ReactiveProperty, adapted from SystemsRx.Tests.Plugins.ReactiveData 
 */
class ReactivePropertyTests extends Test {
	public function test_ValueType() {
		{
			var rp = new ReactiveProperty<Int>(); // 0

			// Для проверки значений, предполагаем, что у ReactiveProperty есть метод для записи истории
			// или используем фиктивный observer для сбора значений.
			// В данном случае просто проверим базовую логику.
			var result_values = [];
			result_values.push(rp.value); // Должно быть 0
			Assert.equals(0, rp.value);

			rp.value = 0;
			result_values.push(rp.value); // Должно быть 0
			Assert.equals(0, rp.value);

			rp.value = 10;
			result_values.push(rp.value); // Должно быть 10
			Assert.equals(10, rp.value);

			rp.value = 100;
			result_values.push(rp.value); // Должно быть 100
			Assert.equals(100, rp.value);

			rp.value = 100;
			result_values.push(rp.value); // Должно быть 100
			Assert.equals(100, rp.value);

			// Проверка значений
			Assert.equals(0, result_values[0]);
			Assert.equals(0, result_values[1]);
			Assert.equals(10, result_values[2]);
			Assert.equals(100, result_values[3]);
			Assert.equals(100, result_values[4]);
		}
		{
			var rp = new ReactiveProperty<Int>(20);

			var result_values = [];
			result_values.push(rp.value); // Должно быть 20
			Assert.equals(20, rp.value);

			rp.value = 0;
			result_values.push(rp.value); // Должно быть 0
			Assert.equals(0, rp.value);

			rp.value = 10;
			result_values.push(rp.value); // Должно быть 10
			Assert.equals(10, rp.value);

			rp.value = 100;
			result_values.push(rp.value); // Должно быть 100
			Assert.equals(100, rp.value);

			rp.value = 100;
			result_values.push(rp.value); // Должно быть 100
			Assert.equals(100, rp.value);

			// Проверка значений
			Assert.equals(20, result_values[0]);
			Assert.equals(0, result_values[1]);
			Assert.equals(10, result_values[2]);
			Assert.equals(100, result_values[3]);
			Assert.equals(100, result_values[4]);
		}
	}
	// Добавьте другие тесты по аналогии...
	// Тесты для ClassType, ToReadOnlyReactiveProperty и т.д. требуют доработки
	// или создания вспомогательных утилит для записи истории значений.
}