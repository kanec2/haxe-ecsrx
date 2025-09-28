package ecsrxe.components.accessor;

import ecsrxe.entities.IEntity;
import ecsrxe.components.IComponent;

/** 
 * Represents an optimised way to interact with a component type on an entity. 
 * 
 * In most cases you can just use the provided extension methods on IEntity, however for 
 * optimisations purposes this provides you a streamlined way to caching the component 
 * type id and relaying calls through to the underlying entity. 
 * @typeparam T The type of the component. 
 */
interface IComponentAccessor<T:IComponent> {
	/** 
	 * Gets the component type ID for the component type T. 
	 */
	var componentTypeId(get, null):Int;

	/** 
	 * Checks if the entity has a component of type T. 
	 * @param entity The entity to check. 
	 * @return true if the entity has the component, false otherwise. 
	 */
	function has(entity:IEntity):Bool;

	/** 
	 * Gets the component of type T from the entity. 
	 * @param entity The entity to get the component from. 
	 * @return The component of type T. 
	 * @throws Exception if the entity does not have the component. 
	 */
	function get(entity:IEntity):T;

	/** 
	 * Tries to get the component of type T from the entity. 
	 * @param entity The entity to get the component from. 
	 * @param component The component of type T, if found. 
	 * @return true if the component was found, false otherwise. 
	 */
	function tryGet(entity:IEntity, component:Ref<T>):Bool;

	/** 
	 * Removes the component of type T from the entity. 
	 * @param entity The entity to remove the component from. 
	 */
	function remove(entity:IEntity):Void;
}