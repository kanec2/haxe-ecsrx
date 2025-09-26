package ecsrxe.collections.entity;

#if (threads || sys)
import rx.Observable;
#end
import ecsrxe.collections.events.ComponentsChangedEvent;

/** 
 * Interface for notifying about entity component changes. 
 */
interface INotifyingEntityComponentChanges {
	/** 
	 * Observable sequence of components added to entities. 
	 */
	var entityComponentsAdded(get, null):Observable<ComponentsChangedEvent>;

	/** 
	 * Observable sequence of components being removed from entities. 
	 */
	var entityComponentsRemoving(get, null):Observable<ComponentsChangedEvent>;

	/** 
	 * Observable sequence of components removed from entities. 
	 */
	var entityComponentsRemoved(get, null):Observable<ComponentsChangedEvent>;
}