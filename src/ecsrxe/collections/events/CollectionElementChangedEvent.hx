package ecsrxe.collections.events;

/** 
 * Event structure for when an element in a collection changes. 
 * @typeparam T The type of the element. 
 */
@:structInit
class CollectionElementChangedEvent<T> /*implements IEquatable<CollectionElementChangedEvent<T>>*/ {
	public var index(default, null):Int;
	public var oldValue(default, null):T;
	public var newValue(default, null):T;

	public function new(index:Int, oldValue:T, newValue:T) {
		this.index = index;
		this.oldValue = oldValue;
		this.newValue = newValue;
	}

	public function equals(other:CollectionElementChangedEvent<T>):Bool {
		if (other == null)
			return false;
		// Используем == для всех полей
		// Для сложных объектов это будет ссылочное равенство
		// Для простых типов (Int, String и т.д.) это будет равенство значений
		return (index == other.index)
			&& (oldValue == other.oldValue
				|| (oldValue != null && other.oldValue != null && oldValue.equals != null && oldValue.equals(other.oldValue)))
			&& (newValue == other.newValue
				|| (newValue != null && other.newValue != null && newValue.equals != null && newValue.equals(other.newValue)));
	}

	public function toString():String {
		return 'CollectionElementChangedEvent(index: $index, oldValue: $oldValue, newValue: $newValue)';
	}

	public function hashCode():Int {
		// Простая реализация хэш-функции без haxe.ds.Equality
		var hash = index;
		// Для oldValue
		if (oldValue != null) {
			// Попробуем использовать метод hashCode объекта, если он есть
			if (Reflect.hasField(oldValue, "hashCode") && Reflect.isFunction(Reflect.field(oldValue, "hashCode"))) {
				try {
					hash = (hash * 397) ^ Reflect.callMethod(oldValue, Reflect.field(oldValue, "hashCode"), []);
				} catch (e:Dynamic) {
					// Если hashCode бросил исключение, используем простой хэш
					hash = (hash * 397) ^ Std.string(oldValue).length;
				}
			} else {
				// Если метода hashCode нет, используем длину строки как простой хэш
				hash = (hash * 397) ^ Std.string(oldValue).length;
			}
		}
		// Для newValue
		if (newValue != null) {
			// Попробуем использовать метод hashCode объекта, если он есть
			if (Reflect.hasField(newValue, "hashCode") && Reflect.isFunction(Reflect.field(newValue, "hashCode"))) {
				try {
					hash = (hash * 397) ^ Reflect.callMethod(newValue, Reflect.field(newValue, "hashCode"), []);
				} catch (e:Dynamic) {
					// Если hashCode бросил исключение, используем простой хэш
					hash = (hash * 397) ^ Std.string(newValue).length;
				}
			} else {
				// Если метода hashCode нет, используем длину строки как простой хэш
				hash = (hash * 397) ^ Std.string(newValue).length;
			}
		}
		return hash;
	}
}