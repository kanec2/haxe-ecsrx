package systemsrx.reactivedata.dictionaries; /** * Interface for a reactive dictionary that can be modified and observed for changes. * @typeparam TKey The type of keys in the dictionary. * @typeparam TValue The type of values in the dictionary. */ interface IReactiveDictionary<TKey,
	TValue> extends IReadOnlyReactiveDictionary<TKey, TValue> {/** * Gets or sets the value associated with the specified key. */

	function get(key:TKey):TValue;

	function set(key:TKey, value:TValue):TValue; /** * Gets the number of key/value pairs contained in the dictionary. */

	var count(get, null):Int; /** * Gets an iterable collection containing the keys in the dictionary. */

	var keys(get, null):Iterable<TKey>; /** * Gets an iterable collection containing the values in the dictionary. */

	var values(get, null):Iterable<TValue>; /** * Adds the specified key and value to the dictionary. */

	function add(key:TKey, value:TValue):Void; /** * Removes all keys and values from the dictionary. */

	function clear():Void; /** * Removes the value with the specified key from the dictionary. * @return true if the element is successfully found and removed; otherwise, false. */

	function remove(key:TKey):Bool;
}