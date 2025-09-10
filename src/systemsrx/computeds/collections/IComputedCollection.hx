package systemsrx.computeds.collections; #if (threads || sys) import rx.Observable; #end import systemsrx.computeds.IComputed; /** * Interface for a computed collection of elements. * @typeparam T The type of elements in the collection. */ 
interface IComputedCollection<T> extends IComputed<Iterable<T>> /*extends Iterable<T>*/ {/** * Get an element by its index. * @param index The index of the element. */

	// В Haxe, для доступа по индексу в интерфейсе, обычно используется метод function get(index:Int):T; /** * How many elements are within the collection. */ var count(get, null):Int; }