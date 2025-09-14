package systemsrx.pools;

import hx.concurrent.lock.Semaphore;

/** 
 * Pool for managing integer IDs, starting from 1. 
 */
class IdPool implements IPool<Int> {
	#if (threads || sys)
	final semaphore:Semaphore;
	#end

	public var incrementSize(get, null):Int;
	public var availableIds:Array<Int>;

	public var lastMax:Int;
	final _incrementSize:Int;

	public function new(increaseSize:Int = 10000, startingSize:Int = 10000) {
		#if (threads || sys)
		// Бинарный семафор для взаимного исключения (Mutex)
		semaphore = new Semaphore(1);
		#end

		lastMax = startingSize;
		_incrementSize = increaseSize;
		availableIds = [];

		// Заполняем пул ID от 1 до startingSize
		for (i in 1...(startingSize + 1)) {
			availableIds.push(i);
		}
	}

	function get_incrementSize():Int {
		return _incrementSize;
	}

	public function allocateInstance():Int {
		#if (threads || sys)
		semaphore.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;
		var result:Int = 0;

		if (availableIds.length == 0) {
			// Копируем логику расширения с обработкой ошибок
			var expandError = false;
			var expandErrorValue:Dynamic = null;
			try {
				expand();
			} catch (e:Dynamic) {
				expandError = true;
				expandErrorValue = e;
			}

			if (expandError) {
				#if (threads || sys)
				semaphore.release();
				#end
				throw expandErrorValue;
			}
		}

		if (availableIds.length == 0) {
			#if (threads || sys)
			semaphore.release();
			#end
			throw "No ID available after expansion";
		}

		// Берем первый ID из списка
		var id = availableIds.shift();
		if (id == null) {
			#if (threads || sys)
			semaphore.release();
			#end
			throw "No ID available after check";
		}
		result = id;

		#if (threads || sys)
		semaphore.release();
		#end

		return result;
	}

	public function isAvailable(id:Int):Bool {
		// Не требует блокировки для согласованности чтения
		return id > lastMax || availableIds.indexOf(id) != -1;
	}

	public function allocateSpecificId(id:Int):Void {
		if (id <= 0) {
			throw "ID must be >= 1";
		}

		#if (threads || sys)
		semaphore.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;

		if (id > lastMax) {
			// Копируем логику расширения с обработкой ошибок
			var expandError = false;
			var expandErrorValue:Dynamic = null;
			try {
				expand(id);
			} catch (e:Dynamic) {
				expandError = true;
				expandErrorValue = e;
			}

			if (expandError) {
				#if (threads || sys)
				semaphore.release();
				#end
				throw expandErrorValue;
			}
		}

		// Удаляем ID из доступных, если он там есть
		var index = availableIds.indexOf(id);
		if (index != -1) {
			availableIds.splice(index, 1);
		}

		#if (threads || sys)
		semaphore.release();
		#end
	}

	public function releaseInstance(id:Int):Void {
		if (id <= 0) {
			throw "ID must be >= 1";
		}

		#if (threads || sys)
		semaphore.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;

		if (id > lastMax) {
			// Копируем логику расширения с обработкой ошибок
			var expandError = false;
			var expandErrorValue:Dynamic = null;
			try {
				expand(id);
			} catch (e:Dynamic) {
				expandError = true;
				expandErrorValue = e;
			}

			if (expandError) {
				#if (threads || sys)
				semaphore.release();
				#end
				throw expandErrorValue;
			}
		}

		// Добавляем ID обратно в пул, если его там еще нет
		if (availableIds.indexOf(id) == -1) {
			availableIds.push(id);
		}

		#if (threads || sys)
		semaphore.release();
		#end
	}

	public function expand(?newId:Int):Void {
		// Эта функция вызывается только изнутри других методов, которые уже захватили семафор
		// Поэтому она сама не захватывает семафор

		var increaseBy = 0;
		if (newId != null) {
			if (newId > lastMax) {
				// Если newId больше текущего максимума, расширяем до newId
				// Нам нужны ID от (lastMax + 1) до newId включительно
				increaseBy = newId - lastMax;
			} else {
				// newId <= lastMax, не расширяем
				increaseBy = 0;
			}
		} else {
			// newId == null, расширяем на incrementSize
			increaseBy = _incrementSize;
		}

		if (increaseBy > 0) {
			// Добавляем ID от (lastMax + 1) до (lastMax + increaseBy) включительно
			for (i in (lastMax + 1)...(lastMax + increaseBy + 1)) {
				availableIds.push(i);
			}
			// Обновляем lastMax
			lastMax += increaseBy;
		}
	}
}