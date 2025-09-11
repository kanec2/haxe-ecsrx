package systemsrx.reactivedata.collections; #if (concurrent || sys) import rx.Observable; #end import systemsrx.computeds.Unit;

// Используем Unit из computeds

/** * Interface for a read-only reactive collection that can be observed for changes. * @typeparam T The type of elements in the collection. */
interface IReadOnlyReactiveCollection<T> /*extends Iterable<T>*/ /*implements IDisposable*/ {
	/** * Gets the number of elements contained in the collection. */
	var count(get,
		null):Int; /** * Gets the element at the specified index. */ function get(index:Int):T; /** * Returns an observable sequence of collection add events. */ function observeAdd():Observable<CollectionAddEvent<T>>; /** * Returns an observable sequence of count changes. * @param notifyCurrentCount If true, immediately notifies the current count. */ function observeCountChanged(notifyCurrentCount:Bool = false):Observable<Int>; /** * Returns an observable sequence of collection move events. */ function observeMove():Observable<CollectionMoveEvent<T>>; /** * Returns an observable sequence of collection remove events. */ function observeRemove():Observable<CollectionRemoveEvent<T>>; /** * Returns an observable sequence of collection replace events. */ function observeReplace():Observable<CollectionReplaceEvent<T>>; /** * Returns an observable sequence of collection reset events. */ function observeReset():Observable<Unit>;

	// Добавляем метод dispose из IDisposable
	function dispose():Void;
	// Добавляем метод iterator для Iterable<T>
	function iterator():Iterator<T>;
}