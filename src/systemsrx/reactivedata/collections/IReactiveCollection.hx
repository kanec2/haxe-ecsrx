package systemsrx.reactivedata.collections; /** * Interface for a reactive collection that can be modified and observed for changes. * @typeparam T The type of elements in the collection. */ interface IReactiveCollection<T> extends IReadOnlyReactiveCollection<T> {/** * Gets or sets the element at the specified index. */ function get(index:Int):T;

	function set(index:Int,
		value:T):T; /** * Gets the number of elements contained in the collection. */ var count(get, null):Int; /** * Adds an item to the collection. */

	function push(item:T):Int;

	// В Haxe Array.push возвращает новую длину

	/** * Inserts an item to the collection at the specified index. */
	function insert(index:Int, item:T):Void; /** * Removes the item at the specified index. */

	function removeAt(index:Int):Void; /** * Removes all items from the collection. */

	function clear():Void; /** * Moves the item at the specified index to a new location in the collection. * @param oldIndex The zero-based index specifying the location of the item to be moved. * @param newIndex The zero-based index specifying the new location of the item. */ function move(oldIndex:Int,
		newIndex:Int):Void;

}