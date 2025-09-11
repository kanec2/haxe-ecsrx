package systemsrx.reactivedata.collections;

/** 
 * Event structure for when an item is moved within a collection. 
 * @typeparam T The type of the item. 
 */
@:structInit
class CollectionMoveEvent<T> /*implements IEquatable<CollectionMoveEvent<T>>*/ {
	public var oldIndex(default, null):Int;
	public var newIndex(default, null):Int;
	public var value(default, null):T;

	public function new(oldIndex:Int, newIndex:Int, value:T) {
		this.oldIndex = oldIndex;
		this.newIndex = newIndex;
		this.value = value;
	}

	public function toString():String {
		return 'OldIndex:$oldIndex NewIndex:$newIndex Value:$value';
	}

	public function hashCode():Int {
		// Простая реализация hashCode без использования value.hashCode()
		var oldIndexHash = oldIndex;
		var newIndexHash = newIndex << 2;
		// Попытка получить хэш от value
		var valueHash = 0;
		if (value != null) {
			if (Reflect.hasField(value, "hashCode") && Reflect.isFunction(Reflect.field(value, "hashCode"))) {
				try {
					valueHash = Reflect.callMethod(value, Reflect.field(value, "hashCode"), []);
				} catch (e:Dynamic) {
					valueHash = Std.string(value).length;
				}
			} else {
				valueHash = Std.string(value).length;
			}
			valueHash = valueHash >> 2; // Сдвиг для лучшего распределения
		}
		return oldIndexHash ^ newIndexHash ^ valueHash;
	}

	public function equals(other:CollectionMoveEvent<T>):Bool {
		if (other == null)
			return false;
		if (oldIndex != other.oldIndex)
			return false;
		if (newIndex != other.newIndex)
			return false;

		if (value == null && other.value == null)
			return true;
		if (value == null || other.value == null)
			return false;

		if (Reflect.hasField(value, "equals") && Reflect.isFunction(Reflect.field(value, "equals"))) {
			try {
				return Reflect.callMethod(value, Reflect.field(value, "equals"), [other.value]);
			} catch (e:Dynamic) {
				return value == other.value;
			}
		} else {
			return value == other.value;
		}
	}
}