package systemsrx.computeds; #if (concurrent || sys) import rx.observables.IObservable; #end /** * Interface for a computed value that can be observed. * @typeparam T The type of the computed value. */ 
interface IComputed<T> extends IObservable<T> {/** * Gets the current value of the computed. */ var value(get,
	null):T;

}