package ecsrxe.collections.database;

import ecsrxe.collections.entity.INotifyingCollection;
import ecsrxe.collections.entity.IEntityCollection;
import ecsrxe.entities.IEntity;
import ecsrxe.groups.IGroup;
#if (threads || sys)
import rx.Observable;
import rx.disposables.ISubscription;
#end

/** 
 * This acts as the database to store all entities, rather than containing all entities directly 
 * within itself, it partitions them into collections which can contain differing amounts of entities. 
 */
interface IEntityDatabase extends INotifyingCollection /*implements IDisposable*/ {
	/** 
	 * All the entity collections that the manager contains 
	 */
	var collections(get, null):Array<IEntityCollection>;

	/** 
	 * Fired when a collection has been added 
	 */
	var collectionAdded(get, null):Observable<IEntityCollection>;

	/** 
	 * Fired when a collection has been removed 
	 */
	var collectionRemoved(get, null):Observable<IEntityCollection>;

	/** 
	 * Creates a new collection within the database 
	 * 
	 * This is primarily useful for when you want to isolate certain entities, such as short lived ones which would 
	 * be constantly being destroyed and recreated, like bullets etc. In most cases you will probably not need more than 1. 
	 * 
	 * @param id The name to give the collection 
	 * @return A newly created collection with that name 
	 */
	function createCollection(id:Int):IEntityCollection;

	/** 
	 * Adds an existing collection within the database 
	 * 
	 * This is mainly used for when you have persisted a collection and want to re-load it 
	 * 
	 * @param collection The collection to add 
	 */
	function addCollection(collection:IEntityCollection):Void;

	/** 
	 * Gets a collection by id from within the manager, if no id is provided the default pool is returned 
	 * 
	 * @param id The optional id of collection to return 
	 * @return The located collection 
	 * @remarks This is a safe Get so it will return back a null if no collection can be found 
	 */
	function getCollection(?id:Int = EntityCollectionLookups.DefaultCollectionId):IEntityCollection;

	/** 
	 * Provides a mechanism to directly get the collection from the underlying store, however will throw if doesnt exist 
	 * 
	 * @param id The id of the collection 
	 * @remarks This is more performant but unsafe way to access the collections directly by id 
	 */
	function get(id:Int):IEntityCollection;

	/** 
	 * Removes a collection from the manager 
	 * 
	 * @param id The collection to remove 
	 * @param disposeEntities if the entities should all be disposed too 
	 */
	function removeCollection(id:Int, disposeEntities:Bool = true):Void;

	/** 
	 * Disposes of all resources used by the entity database 
	 */
	function dispose():Void;
}