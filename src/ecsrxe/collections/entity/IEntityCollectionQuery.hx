package ecsrxe.collections.entity;

import ecsrxe.entities.IEntity;

/** 
 * A pre made query which will extract relevant entities from the entity collection, this is useful 
 * for wrapping up complex logic. i.e Get all entities who have a component with Health > 25% 
 * 
 * This will run on the live data so every query execution will cause an enumeration through 
 * the collection, this is often undesired for performance reasons but is useful for one off 
 * style queries. 
 */
interface IEntityCollectionQuery {
	/** 
	 * Acts as a way to filter the entity data. 
	 * 
	 * This is often called automatically by other methods which act on the collection itself so its 
	 * rare that you would ever need to Execute yourself manually. 
	 * 
	 * @param entityList The list of entities to enumerate 
	 * @return A filtered collection of entities to enumerate through 
	 */
	function execute(entityList:Iterable<IEntity>):Iterable<IEntity>;
}