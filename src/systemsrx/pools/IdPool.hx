package systemsrx.pools;

#if (threads || sys)
// Используем Semaphore из haxe-concurrent для синхронизации, как в SystemExecutor
import hx.concurrent.lock.Semaphore;
#end

/** 
 * * Pool for managing integer IDs, starting from 1. 
 * * IDs are allocated from a list and can be released back to the pool. 
**/
class IdPool implements IIdPool {
	#if (threads || sys)
	final semaphore:Semaphore;
	#end

	public var incrementSize(get, null):Int;

	var lastMax:Int;
	final _incrementSize:Int;

	/** * List of available IDs. 
	 * * Public for testing, as in the original C#. 
	**/
	public final availableIds:Array<Int>;

	/** 
	 * * Creates a new IdPool. 
	 * * @param increaseSize The amount to increase the pool size by when it's empty. Default is 10000. 
	 * * @param startingSize The initial size of the pool. Default is 10000. 
	**/
	public function new(increaseSize:Int = 10000, startingSize:Int = 10000) {
		#if (threads || sys)
		// Бинарный семафор для взаимного исключения (Mutex)
		semaphore = new Semaphore(1, 1);
		#end
		lastMax = startingSize;
		_incrementSize = increaseSize;
		availableIds = [];
		// Заполняем пул ID от 1 до startingSize, как в C# Enumerable.Range(1, _lastMax)
		for (i in 1...(startingSize + 1)) {
			// 1 to startingSize inclusive
			availableIds.push(i);
		}
	}

	function get_incrementSize():Int {
		return _incrementSize;
	}

	public function allocateInstance():Int {#if (threads || sys) semaphore.acquire(); #end
		try {
			if (availableIds.length == 0) {
				expand();
			}
			// Берем первый ID из списка (как в C# AvailableIds[0] и RemoveAt(0))
			// В Haxe это удобнее сделать через shift()
			var id = availableIds.shift();
			// Если shift() вернул null (не должно произойти, если длина > 0), обработаем
			// Но по логике, если length > 0, shift() должен вернуть значение
			return id != null ? id : throw "No ID available after check";
		}
		catch(e:Dynamic){
            #if (threads || sys) semaphore.release(); #end
            throw e;
        }
		#if (threads || sys) semaphore.release(); #end
	}

	public function isAvailable(id:Int):Bool {
		// Не требует блокировки, так как не модифицирует состояние
		// Но для согласованности чтения в многопоточной среде, возможно, стоит
		// В оригинале C# не было lock, поэтому и мы не используем
		return id > lastMax || availableIds.indexOf(id) != -1;
	}

	public function allocateSpecificId(id:Int):Void {
		if (id <= 0) {
			throw "ID must be >= 1";
		}
		#if (threads || sys) semaphore.acquire(); #end
		try {
			if (id > lastMax) {
				expand(id);
			}
			// Удаляем ID из доступных, если он там есть
			// indexOf вернет -1, если не найден
			var index = availableIds.indexOf(id);
			if (index != -1) {
				availableIds.splice(index, 1);
				// Удаляем один элемент по индексу
			}
			// Если ID не был в списке (уже выделен или за пределами текущего диапазона
			// после expand), то ничего не делаем - он считается выделенным.
		}
		catch(e:Dynamic){
            #if (threads || sys) semaphore.release(); #end
            throw e;
        }
		#if (threads || sys) semaphore.release(); #end
	}

	public function releaseInstance(id:Int):Void {
		if (id <= 0) {
			throw "ID must be >= 1";
		} #if (threads || sys) semaphore.acquire(); #end try {
			if (id > lastMax) {
				expand(id);
			}
			// Добавляем ID обратно в пул, если его там еще нет
			if (availableIds.indexOf(id) == -1) {
				availableIds.push(id);
			}
			// В C# не было проверки на дубликаты, но в Haxe добавим для безопасности
		}
		catch(e:Dynamic){
            #if (threads || sys) semaphore.release(); #end
            throw e;
        }
		#if (threads || sys) semaphore.release(); #end
	}

	/** 
	 * * Expands the pool. 
	 * * @param newId Optional. If provided, expands the pool to include this ID. 
	**/
	public function expand(?newId:Int):Void {
		// Эта функция вызывается только изнутри других методов, которые уже захватили семафор
		// Поэтому она сама не захватывает семафор
		var increaseBy = 0;
		if (newId != null) {
			// Вычисляем, на сколько нужно расширить, чтобы вместить newId
			// newId должен быть доступен, т.е. должен быть <= _lastMax + increaseBy
			// У нас диапазон от 1 до _lastMax. Чтобы newId был доступен, нужно
			// расширить до newId (включительно), если newId > _lastMax.
			// increaseBy = newId - _lastMax;
			// Это количество НОВЫХ ID, которые нужно добавить
			// Но в C# коде было: increaseBy = newId -_lastMax ?? _increaseSize;
			// и потом AvailableIds.AddRange(Enumerable.Range(_lastMax + 1, increaseBy));
			// _lastMax += increaseBy + 1;
			// Это немного запутанно. Давайте разберем:
			// Если newId = 15, _lastMax = 10, то increaseBy = 15 - 10 = 5.
			// Range(_lastMax + 1, increaseBy) = Range(11, 5) = {11, 12, 13, 14, 15}.
			// _lastMax += 5 + 1 = 16.
			// То есть, _lastMax становится на 1 больше, чем максимальный добавленный ID.
			// Это соответствует логике, что IDs 1.._lastMax-1 доступны.
			// Но в нашем случае, IDs 1.._lastMax доступны.
			// Пусть будет как в C# для точности.
			if (newId > lastMax) {
				increaseBy = newId - lastMax;
			} else {
				// Если newId <= lastMax, то расширять не нужно?
				// Или расширить на incrementSize? В C# было ?? _increaseSize
				// Это означает, что если newId - _lastMax даст null (невозможно для int)
				// или 0 или отрицательное, то использовать _increaseSize.
				// Но newId - _lastMax не может быть null для int.
				// Скорее всего, это ошибка в логике C# или опечатка.
				// Предположим, что если newId <= lastMax, то используем incrementSize.
				// Но это противоречит логике allocateSpecificId.
				// Давайте пересмотрим C# код.
				// var increaseBy = newId -_lastMax ?? _increaseSize;
				// Если newId == null, то increaseBy = _increaseSize.
				// Если newId != null, то increaseBy = newId - _lastMax.
				// В сигнатуре метода newId:int? - это Nullable<int> в C#.
				// В Haxe нет Nullable для Int, но мы можем использовать Optional Int.
				// Если newId == null (не передан), то increaseBy = _increaseSize.
				// Это логично для Expand() без параметров.
				// Если передан, то увеличиваем на разницу.
				// Но если newId <= _lastMax, то increaseBy <= 0.
				// В C# это приведет к добавлению отрицательного или нулевого количества элементов.
				// Range с count <= 0 возвращает пустую последовательность.
				// Так что это безопасно.
				// _lastMax += increaseBy + 1. Если increaseBy <= 0, то _lastMax может уменьшиться или остаться.
				// Это выглядит как баг в C# коде.
				// Например: _lastMax=10. Вызываем Expand(5). increaseBy = 5-10 = -5.
				// Range(10+1, -5) = пусто. _lastMax = 10 + (-5) + 1 = 6.
				// Теперь доступны ID 1..5, но _lastMax=6. ID 6 не добавлен, но считается "за пределами".
				// Это странное поведение.
				// Вероятно, имелось в виду: если newId > _lastMax, расширить до newId.
				// Если newId <= _lastMax, не расширять.
				// Но тогда ?? _increaseSize не имеет смысла.
				// Возможно, правильная логика такая:
				// Если newId == null -> расширить на _increaseSize.
				// Если newId != null -> расширить так, чтобы newId стал доступен.
				// В C# это было бы: var increaseBy = newId.HasValue ? Math.Max(0, newId.Value - _lastMax) : _increaseSize;
				// Или, если newId <= _lastMax, то increaseBy = 0.
				// Давайте реализуем логику, ближайшую к разумной интерпретации C# кода.
				// Если newId передан и > _lastMax, расширяем до newId.
				// Если newId передан и <= _lastMax, не расширяем (increaseBy = 0).
				// Expand() без параметров расширяет на _incrementSize.
				increaseBy = 0;
				// newId <= lastMax, не расширяем
			}
		} else {
			// newId == null, расширяем на incrementSize increaseBy = _incrementSize;
		}
		if (increaseBy > 0) {
			// Добавляем ID от (_lastMax + 1) до (_lastMax + increaseBy) включительно
			for (i in (lastMax + 1)...(lastMax + increaseBy + 1)) {
				availableIds.push(i);
			}
			// Обновляем lastMax, чтобы он указывал на максимальный ID + 1
			// Это соответствует логике C# кода
			lastMax += increaseBy; 
            // Коррекция: в C# _lastMax += increaseBy + 1, что выглядит как ошибка. 
            // Если мы добавили increaseBy элементов, _lastMax должен стать // равным lastMax + increaseBy. // Но в C# коде было _lastMax += increaseBy + 1. // Вероятно, это ошибка. Давайте следовать логике: // lastMax - это максимальный ID, который может быть в пуле. // После добавления ID от (lastMax+1) до (lastMax+increaseBy), // новый максимальный ID стал (lastMax+increaseBy). // Поэтому lastMax = lastMax + increaseBy. // Но в C# было _lastMax += increaseBy + 1. // Давайте для точности соответствия повторим ошибку C#. // Нет, лучше исправить. Ошибка в оригинале. // lastMax += increaseBy; // Исправленная логика
		}
	}
}