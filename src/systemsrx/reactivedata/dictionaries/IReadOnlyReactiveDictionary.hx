package systemsrx.reactivedata.dictionaries; #if (threads || sys) import rx.Observable; #end import systemsrx.computeds.Unit;

// Используем Unit из computeds

/** * Interface for a read-only reactive dictionary that can be observed for changes. * @typeparam TKey The type of keys in the dictionary. * @typeparam TValue The type of values in the dictionary. */
interface IReadOnlyReactiveDictionary<TKey,
	TValue> /*extends Iterable<Map.Entry<TKey, TValue>>*/ /*implements IDisposable*/ {/** * Gets the number of key/value pairs contained in the dictionary. */ var count(get,
	null):Int; /** * Gets the value associated with the specified key. */

	function get(key:TKey):TValue; /** * Determines whether the dictionary contains the specified key. */

	function containsKey(key:TKey):Bool; /** * Gets the value associated with the specified key. * @param key The key whose value to get. * @param value When this method returns, the value associated with the specified key, if the key is found; otherwise, the default value for the type of the value parameter. * @return true if the dictionary contains an element with the specified key; otherwise, false. */

	function tryGetValue(key:TKey, value:Ref<TValue>):Bool;

	// В Haxe используем Ref или возвращаем кортеж/объект
	// Observable методы

	/** * Returns an observable sequence of dictionary add events. */
	function observeAdd():Observable<DictionaryAddEvent<TKey, TValue>>; /** * Returns an observable sequence of count changes. */

	function observeCountChanged():Observable<Int>; /** * Returns an observable sequence of dictionary remove events. */

	function observeRemove():Observable<DictionaryRemoveEvent<TKey, TValue>>; /** * Returns an observable sequence of dictionary replace events. */

	function observeReplace():Observable<DictionaryReplaceEvent<TKey, TValue>>; /** * Returns an observable sequence of dictionary reset events. */

	function observeReset():Observable<Unit>;

	// Добавляем метод dispose из IDisposable
	function dispose():Void;
	// Добавляем метод iterator для Iterable
	function iterator():Iterator<{key:TKey, value:TValue}>;
}