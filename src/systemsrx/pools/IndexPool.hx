package systemsrx.pools;

#if (threads || sys)
// Используем Semaphore из haxe-concurrent для синхронизации
import hx.concurrent.lock.Semaphore;
#end

/** 
 * * Pool for managing integer indexes, starting from 0. 
 * * Indexes are allocated from a stack (LIFO) and can be released back to the pool. 
**/
class IndexPool implements IPool<Int> {
	#if (threads || sys)
	final semaphore:Semaphore;
	#end

	public var incrementSize(get, null):Int;

	var lastMax:Int;
	final _incrementSize:Int;

	/** 
	 * * Stack of available indexes. 
	 * * Implemented as Array, using push/pop for stack behavior. 
	 * * Public for testing, as in the original C#. 
	**/
	public final availableIndexes:Array<Int>;

	/** * Creates a new IndexPool. 
	 * * @param increaseSize The amount to increase the pool size by when it's empty. Default is 100. 
	 * * @param startingSize The initial size of the pool. Default is 1000. 
	**/
	public function new(increaseSize:Int = 100, startingSize:Int = 1000) {
		#if (threads || sys) // Бинарный семафор для взаимного исключения (Mutex)
		semaphore = new Semaphore(1, 1); #end lastMax = startingSize;
		_incrementSize = increaseSize;
		availableIndexes = [];

		// Заполняем пул индексами от 0 до startingSize-1 в обратном порядке, как в C#

		// Enumerable.Range(0, _lastMax).Reverse()

		// В Haxe это удобно сделать через цикл в обратном порядке
		for (i in 0...startingSize) {
			availableIndexes.push(startingSize - 1 - i);
			// 999, 998, ..., 1, 0
		}

		// Теперь при pop() мы будем получать 0, 1, 2, ..., 999
	}

	function get_incrementSize():Int {
		return _incrementSize;
	}

	public function allocateInstance():Int {
		#if (threads || sys) semaphore.acquire(); #end
		try {
			if (availableIndexes.length == 0) {
				expand();
			}

			// Берем индекс с вершины стека (как в C# Pop())

			// pop() в Haxe возвращает Null<T>, поэтому проверим
			var index = availableIndexes.pop();
			return index != null ? index : throw "No index available after check";
		} catch (e:Dynamic) {
			#if (threads || sys) semaphore.release(); #end
			throw e;
		}
		#if (threads || sys) semaphore.release(); #end
	}

	public function releaseInstance(index:Int):Void {
		if (index < 0) {
			throw "Index must be >= 0";
		}
		var result:Int = 0;
		#if (threads || sys) semaphore.acquire(); #end
		try {
			if (index > lastMax) {
				expand(index);
			}
			// Добавляем индекс обратно в пул, если его там еще нет
			// Для стека это может быть не так критично, как для ID, но для безопасности
			if (availableIndexes.indexOf(index) == -1) {
				availableIndexes.push(index);
			}
		} catch (e:Dynamic) {
			#if (threads || sys) semaphore.release();
			// Освобождаем до re-throw
			#end throw e; // Повторно бросаем исключение
		}

		{#if (threads || sys) semaphore.release(); #end}
	}

	/** * Expands the pool. * @param newIndex Optional. If provided, expands the pool to include this index. */
	public function expand(?newIndex:Int):Void {
		// Эта функция вызывается только изнутри других методов, которые уже захватили семафор
		var increaseBy = 0;
		if (newIndex != null) {
			// Логика аналогична IdPool, но с индексами от 0
			// Чтобы индекс newIndex стал доступен, нужно, чтобы
			// lastMax было достаточно большим, чтобы newIndex был в диапазоне [0, lastMax-1]
			// или, точнее, чтобы newIndex <= lastMax - 1, т.е. lastMax >= newIndex + 1.
			// Но в C# коде было: increaseBy = (newIndex+1) -_lastMax ?? _increaseSize;
			// И потом: var newEntries = Enumerable.Range(_lastMax, increaseBy).Reverse();
			// foreach(var entry in newEntries) { AvailableIndexes.Push(entry); }
			// _lastMax += increaseBy;
			// Разберем: если newIndex=15, _lastMax=10.
			// increaseBy = (15+1) - 10 = 16 - 10 = 6.
			// Range(_lastMax, increaseBy) = Range(10, 6) = {10, 11, 12, 13, 14, 15}.
			// Reverse() = {15, 14, 13, 12, 11, 10}.
			// Push в стек: 10, 11, 12, 13, 14, 15 (снизу вверх).
			// Pop из стека: 15, 14, 13, 12, 11, 10.
			// _lastMax += 6 = 16.
			// Теперь доступны индексы 0..9 (старые) и 10..15 (новые).
			// _lastMax=16 означает, что максимальный возможный индекс теперь 15.
			// Это логично.
			// Если newIndex=5, _lastMax=10.
			// increaseBy = (5+1) - 10 = -4.
			// Range(10, -4) = пусто.
			// _lastMax += -4 = 6.
			// Это странно: максимальный индекс стал меньше, но старые значения 0..9 остались.
			// Вероятно, это баг в C# коде.
			// Логика должна быть: если newIndex >= _lastMax, расширить.
			// Если newIndex < _lastMax, не расширять.
			if (newIndex >= lastMax) {
				// Вычисляем, на сколько нужно расширить
				// Нам нужны индексы от lastMax до newIndex включительно
				// Количество = newIndex - lastMax + 1
				// Но в C# было (newIndex+1) - _lastMax = newIndex - _lastMax + 1
				// То же самое.
				increaseBy = (newIndex + 1) - lastMax;
			} else {
				// newIndex < lastMax, не расширяем
				increaseBy = 0;
			}
		} else {
			// newIndex == null, расширяем на incrementSize
			increaseBy = _incrementSize;
		}
		// В C# было: if (increaseBy <= 0){ return; }
		// Это защищает от отрицательных значений.
		// В нашей исправленной логике increaseBy не должно быть < 0, но для безопасности
		// добавим проверку.
		if (increaseBy <= 0) {
			return;
		}
		if (increaseBy > 0) {
			// Добавляем индексы от lastMax до (lastMax + increaseBy - 1) в обратном порядке
			// Range(_lastMax, increaseBy).Reverse() в C# эквивалентно:
			var startIndex = lastMax;
			var endIndex = lastMax + increaseBy - 1;
			// Включительно
			// Добавляем в стек в обратном порядке (как Reverse() в C#)
			// Push(entry) для entry от endIndex downto startIndex
			var i = endIndex;
			while (i >= startIndex) {
				availableIndexes.push(i);
				i--;
			}
			// Обновляем lastMax
			lastMax += increaseBy;
		}
	}

	/** * Clears the pool, removing all available indexes. */
	public function clear():Void {
		#if (threads || sys) semaphore.acquire(); #end
		try {
			lastMax = 0;
			availableIndexes.resize(0);
			// Очищаем массив
			// В C# было AvailableIndexes.Clear();
		} catch (e:Dynamic) {
			#if (threads || sys) semaphore.release(); #end
			throw e;
		}

		#if (threads || sys) semaphore.release(); #end
	}

	// Реализация IPool<Int>.releaseInstance уже есть, она принимает Int.
	// Нет необходимости в отдельном методе, если сигнатура совпадает.
}