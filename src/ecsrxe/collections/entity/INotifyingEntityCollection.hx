package ecsrxe.collections.entity;

#if (threads || sys)
import rx.Observable;
#end
import ecsrxe.collections.events.CollectionEntityEvent;

/** 
 * Interface for notifying about entity collection changes. 
 */
interface INotifyingEntityCollection {
	/** 
	 * Observable sequence of entities added to the collection. 
	 */
	var entityAdded(get, null):Observable<CollectionEntityEvent>;

	/** 
	 * Observable sequence of entities removed from the collection. 
	 */
	var entityRemoved(get, null):Observable<CollectionEntityEvent>;
}