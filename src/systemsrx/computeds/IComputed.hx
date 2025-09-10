package systemsrx.computeds; #if (threads || sys) import rx.Observable; #end /** * Interface for a computed value that can be observed. * @typeparam T The type of the computed value. */ interface IComputed<T> extends Observable<T> {/** * Gets the current value of the computed. */ var value(get,
	null):T;

}