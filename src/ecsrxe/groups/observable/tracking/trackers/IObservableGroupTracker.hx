package ecsrxe.groups.observable.tracking.trackers;

#if (threads || sys)
import rx.Observable;
import rx.disposables.ISubscription;
#end
import systemsrx.extensions.IDisposable;
import ecsrxe.groups.observable.tracking.events.EntityGroupStateChanged;

/** 
 * Interface for tracking observable group matching changes. 
 * Provides an observable stream of EntityGroupStateChanged events. 
 */
interface IObservableGroupTracker /*implements IDisposable*/ {
	/** 
	 * Observable stream of entity group state changes. 
	 * Emits EntityGroupStateChanged events when an entity's matching status changes. 
	 */
	#if (threads || sys)
	var groupMatchingChanged(get, null):Observable<EntityGroupStateChanged>;
	#else
	var groupMatchingChanged(get, null):Dynamic; // Заглушка для платформ без поддержки

	#end
	/** 
	 * Gets the observable stream of entity group state changes. 
	 * @return An observable stream of EntityGroupStateChanged events. 
	 */
	#if (threads || sys)
	function get_groupMatchingChanged():Observable<EntityGroupStateChanged>;
	#else
	function get_groupMatchingChanged():Dynamic; // Заглушка для платформ без поддержки

	#end

	/** 
	 * Disposes of all resources used by the tracker. 
	 */
	function dispose():Void;
}