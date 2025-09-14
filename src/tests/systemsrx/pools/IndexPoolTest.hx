package tests.systemsrx.pools;

import utest.Assert;
import utest.Test;
import systemsrx.pools.IndexPool;

/** 
 * Tests for IndexPool, adapted from SystemsRx.Tests.SystemsRx.Pools.IndexPoolTests 
 */
class IndexPoolTest extends Test {
	public function test_should_allocate_up_front_indexes() {
		var indexPool = new IndexPool(3, 3);
		Assert.equals(3, indexPool.availableIndexes.length);

		// Проверяем, что содержатся правильные значения
		// IndexPool инициализируется значениями от 0 до startingSize-1 в ОБРАТНОМ порядке.
		// Это имитирует Stack<int> из C#, где Push(i) добавляет в конец, а Pop() удаляет с конца.
		// availableIndexes = [2, 1, 0]. Pop() -> 0.
		Assert.equals(2, indexPool.availableIndexes[0]); // Вершина стека (первый pop)
		Assert.equals(1, indexPool.availableIndexes[1]);
		Assert.equals(0, indexPool.availableIndexes[2]); // Дно стека
	}

	public function test_should_expand_correctly_for_new_indexes() {
		var explicitNewIndex = 5;
		var indexPool = new IndexPool(3, 3);
		// После инициализации: availableIndexes = [2, 1, 0]
		indexPool.expand(explicitNewIndex);
		// После expand(5):
		// lastMax = 3. newIndex = 5. increaseBy = (5+1) - 3 = 3.
		// Нужно добавить индексы 3, 4, 5.
		// C# логика: Range(3, 3) -> {3, 4, 5}. Reverse() -> {5, 4, 3}. Push each.
		// availableIndexes = [2, 1, 0, 5, 4, 3]. Pop() -> 3.
		// В терминах Haxe Array (pop удаляет с конца):
		// availableIndexes.push(5), push(4), push(3).
		// availableIndexes = [2, 1, 0, 5, 4, 3]. Pop() -> 3.

		Assert.equals(6, indexPool.lastMax); // 3 (было) + 3 (increaseBy)
		Assert.equals(6, indexPool.availableIndexes.length);

		// Проверяем содержимое (как стек)
		var expectedIndexesBottomToTop = [2, 1, 0, 5, 4, 3]; // от дна к вершине стека
		for (i in 0...expectedIndexesBottomToTop.length) {
			Assert.equals(expectedIndexesBottomToTop[i], indexPool.availableIndexes[i]);
		}
	}

	public function test_should_allocate_and_remove_next_available_index() {
		var indexPool = new IndexPool(10, 10);
		// После инициализации: availableIndexes = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
		var index = indexPool.allocateInstance();
		// allocateInstance() вызывает pop(), который возвращает элемент с ВЕРШИНЫ стека.
		// Вершина стека - это ПЕРВЫЙ элемент в массиве [9, 8, ...] или ПОСЛЕДНИЙ в [0, 1, ...].
		// В нашем случае это 0.
		Assert.equals(0, index);
		// После этого 0 должно быть удалено из availableIndexes
		// availableIndexes = [9, 8, 7, 6, 5, 4, 3, 2, 1]
		Assert.equals(9, indexPool.availableIndexes.length);
		Assert_false(indexPool.availableIndexes.contains(index));
	}

	public function test_should_expand_and_allocate_and_remove_next_available_index_when_empty() {
		var defaultExpansionAmount = 30;
		var originalSize = 10;
		// ИСПРАВЛЕНИЕ: expectedSize в тесте неправильно рассчитан.
		// expectedSize = defaultExpansionAmount + originalSize; // 40
		// Это не имеет смысла в контексте этого теста.
		// Тест проверяет, что после Clear() и AllocateInstance() (который вызвал Expand()),
		// в availableIndexes.length будет defaultExpansionAmount - 1.
		var indexPool = new IndexPool(defaultExpansionAmount, originalSize);
		// availableIndexes = [9, 8, ..., 0] (10 элементов)
		indexPool.clear(); // availableIndexes = []
		var index = indexPool.allocateInstance();
		// availableIndexes пуст, вызывается expand()
		// expand() без параметров: increaseBy = _incrementSize = 30
		// lastMax = 10. Добавляются индексы от 10 до 39.
		// C# логика: Range(10, 30) -> {10..39}. Reverse() -> {39..10}. Push each.
		// availableIndexes = [39, 38, ..., 10] (30 элементов)
		// allocateInstance() вызывает pop(), который возвращает 10.
		Assert.equals(10, index); // Первый индекс из расширенного пула
		Assert_false(indexPool.availableIndexes.contains(index));

		// Проверим размер
		// ИСПРАВЛЕНИЕ: Ожидаем defaultExpansionAmount - 1, а не expectedSize - 1
		// После Expand() в availableIndexes 30 элементов.
		// После pop() в availableIndexes 29 элементов.
		Assert.equals(defaultExpansionAmount - 1, indexPool.availableIndexes.length); // 29

		// Проверим, что остальные элементы на месте (примерно)
		// availableIndexes = [39, 38, ..., 11]
		Assert_true(indexPool.availableIndexes.contains(39));
		Assert_true(indexPool.availableIndexes.contains(11));
	}

	// Добавьте другие тесты по аналогии...
}

// Вспомогательные функции
private function Assert_false(condition:Bool, ?msg:String, ?pos:haxe.PosInfos) {
	Assert.isTrue(!condition, msg, pos);
}

private function Assert_true(condition:Bool, ?msg:String, ?pos:haxe.PosInfos) {
	Assert.isTrue(condition, msg, pos);
}