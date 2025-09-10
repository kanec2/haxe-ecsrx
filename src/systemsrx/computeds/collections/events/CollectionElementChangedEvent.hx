package systemsrx.computeds.collections.events; /** * Event structure for when an element in a collection changes. * @typeparam T The type of the element. */

@:structInit class CollectionElementChangedEvent<T> /*implements IEquatable<CollectionElementChangedEvent<T>>*/ {
	public var index:Int;
	public var oldValue:T;
	public var newValue:T;

	public function new(index:Int, oldValue:T, newValue:T) {
		this.index = index;
		this.oldValue = oldValue;
		this.newValue = newValue;
	}

	public function equals(other:CollectionElementChangedEvent<T>):Bool {
		if (other == null)
			return false;
		// Используем Std.is и cast для проверки типа
		// И используем equality для значений, если они поддерживают equals,
		// иначе используем == для простых типов или ссылочное равенство для объектов
		return (index == other.index)
			&& (oldValue == other.oldValue
				|| (Reflect.hasField(oldValue, "equals")
					&& Reflect.callMethod(oldValue, Reflect.field(oldValue, "equals"), [other.oldValue])))
			&& (newValue == other.newValue
				|| (Reflect.hasField(newValue, "equals")
					&& Reflect.callMethod(newValue, Reflect.field(newValue, "equals"), [other.newValue])));
	}

	public function toString():String {
		return 'CollectionElementChangedEvent(index: $index, oldValue: $oldValue, newValue: $newValue)';
	}

	// Реализация hashCode в Haxe не требуется так же явно, как в C#
	// но если нужно, можно добавить метод hashCode():Int
}