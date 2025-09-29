package ecsrxe.groups.observable;

import ecsrxe.entities.IEntity;
import ecsrxe.groups.observable.IObservableGroup;
#if (threads || sys)
import rx.Observable;
import rx.disposables.ISubscription;
#end

/** 
 * Interface for querying entities within an observable group. 
 * 
 * This acts as a pre-made query which will extract relevant entities from the observable group, 
 * this is useful for wrapping up complex logic. e.g Get all entities who have a component with Health > 25%. 
 * 
 * This will run on the live data so every query execution will cause an enumeration through 
 * the group, this is often undesired for performance reasons but is useful for one-off 
 * style queries. 
 */
interface IObservableGroupQuery {
	/** 
	 * Executes the query against the observable group and returns the matching entities. 
	 * 
	 * Acts as a way to filter the entity data. 
	 * 
	 * This is often called automatically by other methods which act on the group itself so its 
	 * rare that you would ever need to Execute yourself manually. 
	 * 
	 * @param observableGroup The observable group to query. 
	 * @return An enumerable sequence of entities that match the query. 
	 */
	function execute(observableGroup:IObservableGroup):Iterable<IEntity>;
}