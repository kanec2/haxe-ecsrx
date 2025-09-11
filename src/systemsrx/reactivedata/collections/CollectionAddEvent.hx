package systemsrx.reactivedata.collections;

/** 
 * Event structure for when an item is added to a collection. 
 * @typeparam T The type of the item. 
 */
@:structInit
class CollectionAddEvent<T> /*implements IEquatable<CollectionAddEvent<T>>*/ {
	public var index(default, null):Int;
	public var value(default, null):T;

	public function new(index:Int, value:T) {
		this.index = index;
		this.value = value;
	}

	public function toString():String {
		return 'Index:$index Value:$value';
	}

	public function hashCode():Int {
		// Простая реализация hashCode без использования value.hashCode()
		// Используем только index для хэширования, так как value может не иметь hashCode
		// Для более сложных сценариев может потребоваться кастомный компаратор.
		var indexHash = (index * 31); // Стандартная практика умножения на простое число
		// Попытка получить хэш от value, если это возможно
		var valueHash = 0;
		if (value != null) {
			// Проверяем, есть ли у value метод hashCode
			if (Reflect.hasField(value, "hashCode") && Reflect.isFunction(Reflect.field(value, "hashCode"))) {
				try {
					valueHash = Reflect.callMethod(value, Reflect.field(value, "hashCode"), []);
				} catch (e:Dynamic) {
					// Игнорируем ошибки, используем стандартный хэш строки
					valueHash = Std.string(value).length; // Простая замена: длина строки
				}
			} else {
				// Если метода hashCode нет, используем длину строки как простой хэш
				valueHash = Std.string(value).length;
			}
		}
		// Комбинируем хэши
		return indexHash ^ (valueHash << 2); // Сдвиг для лучшего распределения
	}

	public function equals(other:CollectionAddEvent<T>):Bool {
		if (other == null)
			return false;
		// Проверяем равенство по ссылке или по значению полей
		// Для index используем строгое равенство
		if (index != other.index)
			return false;

		// Для value используем более гибкое сравнение
		if (value == null && other.value == null)
			return true;
		if (value == null || other.value == null)
			return false;

		// Если оба значения не null, сравниваем их
		// Сначала пытаемся использовать метод equals, если он есть
		if (Reflect.hasField(value, "equals") && Reflect.isFunction(Reflect.field(value, "equals"))) {
			try {
				return Reflect.callMethod(value, Reflect.field(value, "equals"), [other.value]);
			} catch (e:Dynamic) {
				// Если equals бросил исключение, используем ==
				return value == other.value;
			}
		} else {
			// Если метода equals нет, используем ==
			return value == other.value;
		}
	}
}