package systemsrx.reactivedata; #if (concurrent || sys) import rx.Observable;
import rx.observables.IObservable; // Убедитесь, что путь правильный
import rx.observers.IObserver;
import rx.disposables.ISubscription; #end /** * Interface for a read-only reactive property. * It's an Observable that holds a value and can be disposed. * @typeparam T The type of the value. */ 
interface IReadOnlyReactiveProperty<T> extends IObservable<T> /*implements IDisposable*/ {/** * Gets the current value of the property. */ var value(get,
	null):T; /** * Gets a value indicating whether the property has a value. */ var hasValue(get, null):Bool;

	// Добавляем метод dispose из IDisposable 
    function dispose():Void; 
}