package ecsrxe.collections;

#if (threads || sys)
import rx.Observable;
import rx.disposables.ISubscription;
#end
import ecsrxe.collections.groups.observable.IObservableGroup;
import ecsrxe.groups.IGroup;

/** 
 * Manages observable groups of entities that match certain criteria. 
 */
interface IObservableGroupManager /*implements IDisposable*/ {
	/** 
	 * Gets the list of all observable groups managed by this manager. 
	 */
	var observableGroups(get, null):Array<IObservableGroup>;

	/** 
	 * Gets the observable groups that are applicable for entities with the given component type IDs. 
	 * @param componentTypeIds The component type IDs to match. 
	 * @return An enumerable of observable groups that match the criteria. 
	 */
	function getApplicableGroups(componentTypeIds:Array<Int>):Iterable<IObservableGroup>;

	/** 
	 * Gets an ObservableGroup which will observe the given group and maintain a collection of 
	 * entities which are applicable. This is the preferred way to access entities inside collections. 
	 * 
	 * It is worth noting that IObservableGroup instances are cached within the manager, so if there is 
	 * a request for an observable group targeting the same underlying components (not the IGroup instance, but 
	 * the actual components the group cares about) it will return the existing group. If one does not exist 
	 * it is created. 
	 * 
	 * @param group The group to match entities on. 
	 * @param collectionIds The collection names to use (defaults to null). 
	 * @return An IObservableGroup monitoring the group passed in. 
	 */
	function getObservableGroup(group:IGroup, ?collectionIds:Array<Int>):IObservableGroup;

	/** 
	 * Disposes of all resources used by the observable group manager. 
	 */
	function dispose():Void;
}