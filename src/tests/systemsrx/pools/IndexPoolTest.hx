package tests.systemsrx.pools;

import utest.Assert;
import utest.Test;
import systemsrx.pools.IndexPool;

// import haxe.iterators.Range; // Если нужен Range

/** 
 * Tests for IndexPool, adapted from SystemsRx.Tests.SystemsRx.Pools.IndexPoolTests 
 */
class IndexPoolTest extends Test {
	public function test_should_allocate_up_front_indexes() {
		var indexPool = new IndexPool(3, 3);
		Assert.equals(3, indexPool.availableIndexes.length);

		// Проверяем, что содержатся правильные значения
		// IndexPool инициализируется значениями от 0 до startingSize-1 в обратном порядке
		// То есть [2, 1, 0]
		Assert.equals(2, indexPool.availableIndexes[0]);
		Assert.equals(1, indexPool.availableIndexes[1]);
		Assert.equals(0, indexPool.availableIndexes[2]);
	}

	public function test_should_expand_correctly_for_new_indexes() {
		var explicitNewIndex = 5;
		var indexPool = new IndexPool(3, 3);
		// После инициализации: availableIndexes = [2, 1, 0]
		indexPool.expand(explicitNewIndex);
		// expand(5) должен добавить индексы от 3 до 5 в обратном порядке: [5, 4, 3]
		// Итоговый массив: [2, 1, 0, 5, 4, 3]
		// Длина должна быть 6 (3 исходных + 3 добавленных)
		// Но в C# тесте Assert.Equal(explicitNewIndex+1, indexPool.AvailableIndexes.Count);
		// explicitNewIndex+1 = 6. Это означает, что после expand(5)
		// availableIndexes должен содержать индексы от 0 до 5, т.е. 6 элементов.
		// Логика C# expand: добавляет индексы от lastMax до (lastMax + increaseBy - 1)
		// где increaseBy = (newIndex+1) - lastMax.
		// lastMax после инициализации = 3.
		// increaseBy = (5+1) - 3 = 3.
		// Добавляются индексы от 3 до 5 (включительно) в обратном порядке: [5, 4, 3].
		// availableIndexes = [2, 1, 0, 5, 4, 3]. Length = 6.
		Assert.equals(explicitNewIndex + 1, indexPool.availableIndexes.length);

		// Проверяем содержимое
		var expectedIndexes = [2, 1, 0, 5, 4, 3];
		for (i in 0...expectedIndexes.length) {
			Assert.equals(expectedIndexes[i], indexPool.availableIndexes[i]);
		}
	}

	public function test_should_allocate_and_remove_next_available_index() {
		var indexPool = new IndexPool(10, 10);
		// После инициализации: [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
		var index = indexPool.allocateInstance();
		// allocateInstance() вызывает pop(), который возвращает первый элемент массива
		// То есть 9.
		Assert.equals(9, index);
		// После этого 9 должно быть удалено из availableIndexes
		// availableIndexes = [8, 7, 6, 5, 4, 3, 2, 1, 0]
		Assert.equals(9, indexPool.availableIndexes.length);
		Assert_false(indexPool.availableIndexes.contains(index));
	}

	// Добавьте другие тесты по аналогии...
	public function test_should_expand_and_allocate_and_remove_next_available_index_when_empty() {
		var defaultExpansionAmount = 30;
		var originalSize = 10;
		var expectedSize = defaultExpansionAmount + originalSize; // 40
		var indexPool = new IndexPool(defaultExpansionAmount, originalSize);
		// availableIndexes = [9, 8, ..., 0] (10 элементов)
		indexPool.clear(); // availableIndexes = []
		var index = indexPool.allocateInstance();
		// availableIndexes пуст, вызывается expand()
		// expand() без параметров: increaseBy = _incrementSize = 30
		// lastMax = 10. Добавляются индексы от 10 до 39 в обратном порядке.
		// availableIndexes = [39, 38, ..., 10] (30 элементов)
		// allocateInstance() возвращает 39.
		Assert.equals(39, index); // Последний добавленный индекс
		Assert_false(indexPool.availableIndexes.contains(index));

		// Проверим размер
		Assert.equals(expectedSize - 1, indexPool.availableIndexes.length); // 39

		// Проверим, что остальные элементы на месте (примерно)
		// availableIndexes = [38, 37, ..., 10]
		Assert_true(indexPool.availableIndexes.contains(38));
		Assert_true(indexPool.availableIndexes.contains(10));
	}
}

// Вспомогательные функции, так как utest.Assert может не иметь всех нужных методов
private function Assert_false(condition:Bool, ?msg:String, ?pos:haxe.PosInfos) {
	Assert.isTrue(!condition, msg, pos);
}

private function Assert_true(condition:Bool, ?msg:String, ?pos:haxe.PosInfos) {
	Assert.isTrue(condition, msg, pos);
}