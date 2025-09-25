package ecsrxe.entities;

import systemsrx.factories.IFactory;
import ecsrxe.entities.IEntity;

/** 
 * Creates entities with given Ids 
 * This is meant to be implemented if you want to create your own IEntity 
 * implementations as this acts as an abstraction layer over how the entities are created 
 */
interface IEntityFactory extends IFactory<Int, IEntity> {
	/** 
	 * Destroys an entity with the given id 
	 * @param entityId The id of the entity to destroy 
	 */
	function destroy(entityId:Int):Void;
}