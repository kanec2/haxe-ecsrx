package systemsrx.reactivedata.collections; /** * Event structure for when an item is added to a collection. * @typeparam T The type of the item. */ @:structInit class CollectionAddEvent<T> /*implements IEquatable<CollectionAddEvent<T>>*/ {

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
		// Простая реализация hashCode
		// В C# было: Index.GetHashCode() ^ EqualityComparer<T>.Default.GetHashCode(Value) << 2;
		// В Haxe используем Std.is и Reflect для более гибкой обработки
		var valueHash = (value != null) ? (try value.hashCode() catch (e:Dynamic) Std.string(value).length) : 0;
		return (index * 31) ^ (valueHash << 2);
	}

	public function equals(other:CollectionAddEvent<T>):Bool {
		if (other == null)
			return false;
		// В C# было: Index.Equals(other.Index) && EqualityComparer<T>.Default.Equals(Value, other.Value);
		// В Haxe:
		return (index == other.index)
			&& (value == other.value || (value != null && other.value != null && value.equals != null && value.equals(other.value)));
	}
}