package systemsrx.reactivedata.collections; /** * Event structure for when an item is moved within a collection. * @typeparam T The type of the item. */ @:structInit class CollectionMoveEvent<T> /*implements IEquatable<CollectionMoveEvent<T>>*/ {

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
		// В C# было: OldIndex.GetHashCode() ^ NewIndex.GetHashCode() << 2 ^ EqualityComparer<T>.Default.GetHashCode(Value) >> 2;
		var oldIndexHash = oldIndex;
		var newIndexHash = newIndex << 2;
		var valueHash = (value != null) ? (try value.hashCode() catch (e:Dynamic) Std.string(value).length) : 0;
		valueHash = valueHash >> 2;
		return oldIndexHash ^ newIndexHash ^ valueHash;
	}

	public function equals(other:CollectionMoveEvent<T>):Bool {
		if (other == null)
			return false;
		// В C# было: OldIndex.Equals(other.OldIndex) && NewIndex.Equals(other.NewIndex) && EqualityComparer<T>.Default.Equals(Value, other.Value);
		return (oldIndex == other.oldIndex)
			&& (newIndex == other.newIndex)
			&& (value == other.value || (value != null && other.value != null && value.equals != null && value.equals(other.value)));
	}
}