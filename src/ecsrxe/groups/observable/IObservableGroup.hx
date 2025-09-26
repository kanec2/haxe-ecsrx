package ecsrxe.groups.observable;

#if (threads || sys)
import rx.Observable;
import rx.disposables.ISubscription;
#end
import ecsrxe.entities.IEntity;
import ecsrxe.groups.observable.ObservableGroupToken;

/** 
 * A maintained collection of entities which match a given group. 
 * 
 * Implements Iterable so you can just iterate the entities within the group. 
 * 
 * This is quite often going to be a cached list of entities which 
 * is kept up to date based off events being reported, so it is often 
 * more performant to use this rather than querying a collection directly. 
 * This can change based upon implementations though. 
 */
interface IObservableGroup /*extends Iterable<IEntity>*/ /*implements IDisposable*/ {
	/** 
	 * The underlying token that is used to describe the group. 
	 * 
	 * The token contains both components required and the specific collection 
	 * it should be targeting if its been setup to only observe a given collection. 
	 */
	var token(default, null):ObservableGroupToken;

	/** 
	 * Event stream for when an entity has been added to this group. 
	 */
	var onEntityAdded(get, null):Observable<IEntity>;

	/** 
	 * Event stream for when an entity has been removed from this group. 
	 */
	var onEntityRemoved(get, null):Observable<IEntity>;

	/** 
	 * Event stream for when an entity is about to be removed from this group. 
	 */
	var onEntityRemoving(get, null):Observable<IEntity>;

	/** 
	 * Gets the number of entities in the group. 
	 */
	var count(get, null):Int;

	/** 
	 * Gets an entity by index. 
	 */
	function get(index:Int):IEntity;

	/** 
	 * Checks if the observable group contains a given entity. 
	 * @param id The Id of the entity you want to locate. 
	 * @return true if it finds the entity, false if it cannot. 
	 */
	function containsEntity(id:Int):Bool;

	/** 
	 * Gets an entity by id. 
	 * @param id The Id of the entity you want to locate. 
	 * @return The entity with the given id, or null if not found. 
	 */
	function getEntity(id:Int):IEntity;

	/** 
	 * Disposes of all resources used by the observable group. 
	 */
	function dispose():Void;

	/** 
	 * Returns an iterator over the entities in the collection 
	 * This makes the collection Iterable<IEntity> 
	 */
	function iterator():Iterator<IEntity>;

	// Вспомогательные методы для доступа к observables
	function get_onEntityAdded():Observable<IEntity>;
	function get_onEntityRemoved():Observable<IEntity>;
	function get_onEntityRemoving():Observable<IEntity>;
}