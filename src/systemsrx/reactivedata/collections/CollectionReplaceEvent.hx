package systemsrx.reactivedata.collections;

/** 
 * Event structure for when an item is replaced in a collection. 
 * @typeparam T The type of the item. 
 */
@:structInit
class CollectionReplaceEvent<T> /*implements IEquatable<CollectionReplaceEvent<T>>*/ {
	public var index(default, null):Int;
	public var oldValue(default, null):T;
	public var newValue(default, null):T;

	public function new(index:Int, oldValue:T, newValue:T) {
		this.index = index;
		this.oldValue = oldValue;
		this.newValue = newValue;
	}

	public function toString():String {
		return 'Index:$index OldValue:$oldValue NewValue:$newValue';
	}

	public function hashCode():Int {
		// Простая реализация hashCode без использования value.hashCode()
		var indexHash = index;
		var oldValueHash = 0;
		var newValueHash = 0;

		if (oldValue != null) {
			if (Reflect.hasField(oldValue, "hashCode") && Reflect.isFunction(Reflect.field(oldValue, "hashCode"))) {
				try {
					oldValueHash = Reflect.callMethod(oldValue, Reflect.field(oldValue, "hashCode"), []);
				} catch (e:Dynamic) {
					oldValueHash = Std.string(oldValue).length;
				}
			} else {
				oldValueHash = Std.string(oldValue).length;
			}
			oldValueHash = oldValueHash << 2;
		}

		if (newValue != null) {
			if (Reflect.hasField(newValue, "hashCode") && Reflect.isFunction(Reflect.field(newValue, "hashCode"))) {
				try {
					newValueHash = Reflect.callMethod(newValue, Reflect.field(newValue, "hashCode"), []);
				} catch (e:Dynamic) {
					newValueHash = Std.string(newValue).length;
				}
			} else {
				newValueHash = Std.string(newValue).length;
			}
			newValueHash = newValueHash >> 2;
		}

		return indexHash ^ oldValueHash ^ newValueHash;
	}

	public function equals(other:CollectionReplaceEvent<T>):Bool {
		if (other == null)
			return false;
		if (index != other.index)
			return false;

		// Сравнение oldValue
		if (oldValue == null && other.oldValue == null) {
			// Оба null - OK
		} else if (oldValue == null || other.oldValue == null) {
			// Один null, другой нет - не равны
			return false;
		} else {
			// Оба не null - сравниваем
			var oldValuesEqual = false;
			if (Reflect.hasField(oldValue, "equals") && Reflect.isFunction(Reflect.field(oldValue, "equals"))) {
				try {
					oldValuesEqual = Reflect.callMethod(oldValue, Reflect.field(oldValue, "equals"), [other.oldValue]);
				} catch (e:Dynamic) {
					oldValuesEqual = oldValue == other.oldValue;
				}
			} else {
				oldValuesEqual = oldValue == other.oldValue;
			}
			if (!oldValuesEqual)
				return false;
		}

		// Сравнение newValue
		if (newValue == null && other.newValue == null) {
			// Оба null - OK
			return true;
		} else if (newValue == null || other.newValue == null) {
			// Один null, другой нет - не равны
			return false;
		} else {
			// Оба не null - сравниваем
			var newValuesEqual = false;
			if (Reflect.hasField(newValue, "equals") && Reflect.isFunction(Reflect.field(newValue, "equals"))) {
				try {
					newValuesEqual = Reflect.callMethod(newValue, Reflect.field(newValue, "equals"), [other.newValue]);
				} catch (e:Dynamic) {
					newValuesEqual = newValue == other.newValue;
				}
			} else {
				newValuesEqual = newValue == other.newValue;
			}
			return newValuesEqual;
		}

		return true;
	}
}