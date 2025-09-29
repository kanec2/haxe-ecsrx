package ecsrxe.groups.observable.tracking.trackers;

#if (threads || sys)
import rx.Observable;
import rx.disposables.ISubscription;
#end
import systemsrx.extensions.IDisposable;
import ecsrxe.groups.observable.tracking.events.EntityGroupStateChanged;
import ecsrxe.groups.observable.tracking.trackers.IObservableGroupTracker;

/** 
 * Interface for tracking an collection entity's observable group matching changes. 
 * Extends IObservableGroupTracker to provide a way to check if the entity is currently matching the group. 
 */
interface ICollectionObservableGroupTracker extends IObservableGroupTracker {
	/** 
	 * Checks if the collection entity is currently matching the group. 
	 * @return true if the collection entity is matching, false otherwise. 
	 */
	function isMatching():Bool;
}