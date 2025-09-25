package ecsrxe.groups;

/** 
 * Interface for defining a group of components. 
 * A group specifies which components are required and which are excluded for entities to belong to it. 
 */
interface IGroup {
	/** 
	 * Gets the array of component types that are required for an entity to belong to this group. 
	 */
	var requiredComponents(get, null):Array<Class<Dynamic>>;

	/** 
	 * Gets the array of component types that are excluded for an entity to belong to this group. 
	 */
	var excludedComponents(get, null):Array<Class<Dynamic>>;
}