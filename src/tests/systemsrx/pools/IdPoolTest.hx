package tests.systemsrx.pools;

import utest.Assert;
import utest.Test;
import systemsrx.pools.IdPool;

/** 
 * Tests for IdPool, adapted from SystemsRx.Tests.SystemsRx.Pools.IdPoolTests 
 */
class IdPoolTest extends Test {
	public function test_should_allocate_up_front_ids() {
		var idPool = new IdPool(10, 10);
		Assert.equals(10, idPool.availableIds.length);
		// availableIds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		for (i in 1...11) {
			Assert_true(idPool.availableIds.contains(i));
		}
	}

	public function test_should_allocate_and_remove_next_available_id() {
		var idPool = new IdPool(10, 10);
		// availableIds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		var id = idPool.allocateInstance();
		// allocateInstance() вызывает shift(), который возвращает первый элемент массива
		// То есть 1.
		Assert.equals(1, id);
		// После этого 1 должно быть удалено из availableIds
		// availableIds = [2, 3, 4, 5, 6, 7, 8, 9, 10]
		Assert.equals(9, idPool.availableIds.length);
		Assert_false(idPool.availableIds.contains(id));
	}

	public function test_should_expand_and_allocate_and_remove_next_available_id_when_empty() {
		var defaultExpansionAmount = 30;
		var originalSize = 10;
		var expectedSize = defaultExpansionAmount + originalSize; // 40
		var idPool = new IdPool(defaultExpansionAmount, originalSize);
		// availableIds = [1, 2, ..., 10]
		idPool.availableIds.resize(0); // Очищаем, как AvailableIds.Clear() в C#
		// availableIds = []
		var id = idPool.allocateInstance();
		// availableIds пуст, вызывается expand()
		// expand() без параметров: increaseBy = _incrementSize = 30
		// lastMax = 10. Добавляются ID от 11 до 40.
		// availableIds = [11, 12, ..., 40]
		// allocateInstance() возвращает 11.
		Assert.equals(11, id); // Первый ID из расширенного пула
		Assert_false(idPool.availableIds.contains(id));

		// Проверим размер
		Assert.equals(expectedSize - 1, idPool.availableIds.length); // 39

		// Проверим, что остальные элементы на месте (примерно)
		Assert_true(idPool.availableIds.contains(12));
		Assert_true(idPool.availableIds.contains(40));
	}

	// Добавьте другие тесты по аналогии...
}

private function Assert_false(condition:Bool, ?msg:String, ?pos:haxe.PosInfos) {
	Assert.isTrue(!condition, msg, pos);
}

private function Assert_true(condition:Bool, ?msg:String, ?pos:haxe.PosInfos) {
	Assert.isTrue(condition, msg, pos);
}