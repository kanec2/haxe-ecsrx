package systemsrx.reactivedata.dictionaries; /** * Event structure for when an item is added to a dictionary. * @typeparam TKey The type of the key. * @typeparam TValue The type of the value. */ @:structInit class DictionaryAddEvent<TKey,
	TValue> /*implements IEquatable<DictionaryAddEvent<TKey, TValue>>*/ {

	public var key(default, null):TKey;
	public var value(default, null):TValue;

	public function new(key:TKey, value:TValue) {
		this.key = key;
		this.value = value;
	}

	public function toString():String {
		return 'Key:$key Value:$value';
	}

	public function hashCode():Int {
		// В C# было: EqualityComparer<TKey>.Default.GetHashCode(Key) ^ EqualityComparer<TValue>.Default.GetHashCode(Value) << 2;
		// В Haxe используем Std.is и Reflect для более гибкой обработки
		var keyHash = (key != null) ? (try key.hashCode() catch (e:Dynamic) Std.string(key).length) : 0;
		var valueHash = (value != null) ? (try value.hashCode() catch (e:Dynamic) Std.string(value).length) : 0;
		valueHash = valueHash << 2;
		return keyHash ^ valueHash;
	}

	public function equals(other:DictionaryAddEvent<TKey, TValue>):Bool {
		if (other == null)
			return false;
		// В C# было: EqualityComparer<TKey>.Default.Equals(Key, other.Key) && EqualityComparer<TValue>.Default.Equals(Value, other.Value);
		// В Haxe:
		return (key == other.key || (key != null && other.key != null && key.equals != null && key.equals(other.key)))
			&& (value == other.value || (value != null && other.value != null && value.equals != null && value.equals(other.value)));
	}
}