package systemsrx.reactivedata.collections;

/** 
 * Event structure for when an item is removed from a collection. 
 * @typeparam T The type of the item. 
 */
@:structInit
class CollectionRemoveEvent<T> /*implements IEquatable<CollectionRemoveEvent<T>>*/ {
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
		var indexHash = (index * 31);
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
			valueHash = valueHash << 2;
		}
		return indexHash ^ valueHash;
	}

	public function equals(other:CollectionRemoveEvent<T>):Bool {
		if (other == null)
			return false;
		if (index != other.index)
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