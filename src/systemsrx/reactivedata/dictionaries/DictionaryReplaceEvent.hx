package systemsrx.reactivedata.dictionaries; /** * Event structure for when an item is replaced in a dictionary. * @typeparam TKey The type of the key. * @typeparam TValue The type of the value. */ @:structInit class DictionaryReplaceEvent<TKey,
	TValue> /*implements IEquatable<DictionaryReplaceEvent<TKey, TValue>>*/ {

	public var key(default, null):TKey;
	public var oldValue(default, null):TValue;
	public var newValue(default, null):TValue;

	public function new(key:TKey, oldValue:TValue, newValue:TValue) {
		this.key = key;
		this.oldValue = oldValue;
		this.newValue = newValue;
	}

	public function toString():String {
		return 'Key:$key OldValue:$oldValue NewValue:$newValue';
	}

	public function hashCode():Int {
		// В C# было: EqualityComparer<TKey>.Default.GetHashCode(Key) ^ EqualityComparer<TValue>.Default.GetHashCode(OldValue) << 2 ^ EqualityComparer<TValue>.Default.GetHashCode(NewValue) >> 2;
		var keyHash = (key != null) ? (try key.hashCode() catch (e:Dynamic) Std.string(key).length) : 0;
		var oldValueHash = (oldValue != null) ? (try oldValue.hashCode() catch (e:Dynamic) Std.string(oldValue).length) : 0;
		oldValueHash = oldValueHash << 2;
		var newValueHash = (newValue != null) ? (try newValue.hashCode() catch (e:Dynamic) Std.string(newValue).length) : 0;
		newValueHash = newValueHash >> 2;
		return keyHash ^ oldValueHash ^ newValueHash;
	}

	public function equals(other:DictionaryReplaceEvent<TKey, TValue>):Bool {
		if (other == null)
			return false;
		// В C# было: EqualityComparer<TKey>.Default.Equals(Key, other.Key) && EqualityComparer<TValue>.Default.Equals(OldValue, other.OldValue) && EqualityComparer<TValue>.Default.Equals(NewValue, other.NewValue);
		return (key == other.key || (key != null && other.key != null && key.equals != null && key.equals(other.key)))
			&& (oldValue == other.oldValue
				|| (oldValue != null && other.oldValue != null && oldValue.equals != null && oldValue.equals(other.oldValue)))
			&& (newValue == other.newValue
				|| (newValue != null && other.newValue != null && newValue.equals != null && newValue.equals(other.newValue)));
	}
}