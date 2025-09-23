package systemsrx.events;

#if (threads || sys)
import rx.Observable;
import rx.disposables.ISubscription;
#end

/** 
 * Interface for publishing and subscribing to events. 
 * Modified to accept an object to infer the type T for receive<T>(). 
 */
interface IEventSystem {
	/** 
	 * Publishes a message synchronously for any listeners to action. 
	 * @param message The message to publish. 
	 */
	function publish<T>(message:T):Void;

	/** 
	 * Publishes a message asynchronously to any listeners. 
	 * @param message The message to publish. 
	 */
	function publishAsync<T>(message:T):Void;

	/** 
	 * Listens out for any messages of a given type to be published. 
	 * Modified to accept a prototype object to infer the type T. 
	 * @param prototype An object of type T used to infer the type. 
	 * @return An observable sequence of messages of type T. 
	 */
	#if (threads || sys)
	function receive<T>(prototype:T):Observable<T>;
	#else
	function receive<T>(prototype:T):Observable<T>;
	#end

	/** 
	 * Disposes of all resources used by the event system. 
	 */
	function dispose():Void;
}