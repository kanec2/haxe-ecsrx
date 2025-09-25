package ecsrxe.collections.entity;

import ecsrxe.entities.IEntity;
import ecsrxe.blueprints.IBlueprint;
import rx.Observable;
#if (threads || sys)
import rx.disposables.ISubscription;
#end

/** 
 * The entity collection is a container for entities, it can be seen as a Repository of sorts 
 * as it allows for CRUD based operations and querying (through extensions) 
 */
interface IEntityCollection /*implements Iterable<IEntity>*/ /*implements IDisposable*/ {
	/** 
	 * Name of the collection 
	 */
	var id(default, null):Int;

	/** 
	 * Observable sequence of entities added to the collection 
	 */
	var onEntityAdded(get, null):Observable<IEntity>;

	/** 
	 * Observable sequence of entities removed from the collection 
	 */
	var onEntityRemoved(get, null):Observable<IEntity>;

	/** 
	 * This will create and return a new entity. 
	 * If required you can pass in a blueprint which the created entity will conform to 
	 * @param blueprint Optional blueprint to use for the entity (defaults to null) 
	 * @param id Id to use for the entity (defaults to null, meaning it'll automatically get the next available id) 
	 * @return 
	 */
	function createEntity(?blueprint:IBlueprint, ?id:Int):IEntity;

	/** 
	 * This will add an existing entity into the group, it is mainly used for pre-made 
	 * entities which have been created from persisted data/serializers etc. 
	 * Should be used with care as you should only have an entity in one collection. 
	 * @param entity Entity to add to the collection 
	 */
	function addEntity(entity:IEntity):Void;

	/** 
	 * Gets the entity from the collection, this will return the IEntity or null 
	 * @param id The Id of the entity you want to locate 
	 * @return The entity that has been located or null if one could not be found 
	 */
	function getEntity(id:Int):IEntity;

	/** 
	 * Checks if the collection contains a given entity 
	 * @param id The Id of the entity you want to locate 
	 * @return true if it finds the entity, false if it cannot 
	 */
	function containsEntity(id:Int):Bool;

	/** 
	 * This will remove the entity from the collection and optionally destroy the entity. 
	 * It is worth noting if you try to remove an entity id that does not exist you will get an exception 
	 * @param id The Id of the entity you want to remove 
	 * @param disposeOnRemoval If the entity should be disposed when removed (defaults to true) 
	 */
	function removeEntity(id:Int, disposeOnRemoval:Bool = true):Void;

	/** 
	 * Gets the number of entities in the collection 
	 */
	var count(get, null):Int;

	/** 
	 * Gets an entity by index 
	 */
	function get(index:Int):IEntity;

	/** 
	 * Disposes of all resources used by the collection 
	 */
	function dispose():Void;

	/** 
	 * Returns an iterator over the entities in the collection 
	 */
	function iterator():Iterator<IEntity>;
}