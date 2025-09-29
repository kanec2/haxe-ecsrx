package ecsrxe.groups.observable.tracking.trackers;

import ecsrxe.entities.IEntity;
import ecsrxe.groups.observable.tracking.trackers.ICollectionObservableGroupTracker;

/** 
 * Interface for tracking batches of entities in an observable group. 
 * Extends ICollectionObservableGroupTracker to provide methods for starting and stopping tracking of individual entities. 
 */
interface IBatchObservableGroupTracker extends ICollectionObservableGroupTracker {
	/** 
	 * Starts tracking an entity. 
	 * @param entity The entity to start tracking. 
	 * @return true if the entity was added to tracking, false if it was already being tracked. 
	 */
	function startTrackingEntity(entity:IEntity):Bool;

	/** 
	 * Stops tracking an entity. 
	 * @param entity The entity to stop tracking. 
	 */
	function stopTrackingEntity(entity:IEntity):Void;
}