package systemsrx.reactivedata.collections; /** * Event structure for when an item is replaced in a collection. * @typeparam T The type of the item. */ @:structInit class CollectionReplaceEvent<T> /*implements IEquatable<CollectionReplaceEvent<T>>*/ {

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
		// В C# было: Index.GetHashCode() ^ EqualityComparer<T>.Default.GetHashCode(OldValue) << 2 ^ EqualityComparer<T>.Default.GetHashCode(NewValue) >> 2;
		var indexHash = index;
		var oldValueHash = (oldValue != null) ? (try oldValue.hashCode() catch (e:Dynamic) Std.string(oldValue).length) : 0;
		oldValueHash = oldValueHash << 2;
		var newValueHash = (newValue != null) ? (try newValue.hashCode() catch (e:Dynamic) Std.string(newValue).length) : 0;
		newValueHash = newValueHash >> 2;
		return indexHash ^ oldValueHash ^ newValueHash;
	}

	public function equals(other:CollectionReplaceEvent<T>):Bool {
		if (other == null)
			return false;
		// В C# было: Index.Equals(other.Index) && EqualityComparer<T>.Default.Equals(OldValue, other.OldValue) && EqualityComparer<T>.Default.Equals(NewValue, other.NewValue);
		return (index == other.index)
			&& (oldValue == other.oldValue
				|| (oldValue != null && other.oldValue != null && oldValue.equals != null && oldValue.equals(other.oldValue)))
			&& (newValue == other.newValue
				|| (newValue != null && other.newValue != null && newValue.equals != null && newValue.equals(other.newValue)));
	}
}