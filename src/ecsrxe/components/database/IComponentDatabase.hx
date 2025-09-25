package ecsrxe.components.database;

import ecsrxe.components.IComponent;
import ecsrxe.pools.IPool;

/** 
 * Interface for a component database that manages component allocations and storage. 
 */
interface IComponentDatabase {
	/** 
	 * Gets a component of type T at the specified allocation index. 
	 * @param componentTypeId The type ID of the component. 
	 * @param allocationIndex The index where the component is stored. 
	 * @return The component of type T. 
	 */
	function get<T:IComponent>(componentTypeId:Int, allocationIndex:Int):T;

	/** 
	 * Gets a reference to a component of type T at the specified allocation index. 
	 * @param componentTypeId The type ID of the component. 
	 * @param allocationIndex The index where the component is stored. 
	 * @return A reference to the component of type T. 
	 * @remarks This is meant for struct based components. 
	 */
	function getRef<T:IComponent>(componentTypeId:Int, allocationIndex:Int):T;

	/** 
	 * Gets all components of type T for the specified component type ID. 
	 * @param componentTypeId The type ID of the components. 
	 * @return An array of components of type T. 
	 */
	function getComponents<T:IComponent>(componentTypeId:Int):Array<T>;

	/** 
	 * Sets a component of type T at the specified allocation index. 
	 * @param componentTypeId The type ID of the component. 
	 * @param allocationIndex The index where the component should be stored. 
	 * @param component The component to store. 
	 */
	function set<T:IComponent>(componentTypeId:Int, allocationIndex:Int, component:T):Void;

	/** 
	 * Removes a component at the specified allocation index. 
	 * @param componentTypeId The type ID of the component. 
	 * @param allocationIndex The index where the component is stored. 
	 */
	function remove(componentTypeId:Int, allocationIndex:Int):Void;

	/** 
	 * Allocates a new index for the specified component type ID. 
	 * @param componentTypeId The type ID of the component. 
	 * @return The allocated index. 
	 */
	function allocate(componentTypeId:Int):Int;

	/** 
	 * Pre-allocates components for the specified component type ID. 
	 * @param componentTypeId The type ID of the components. 
	 * @param allocationSize The number of components to pre-allocate. 
	 */
	function preAllocateComponents(componentTypeId:Int, allocationSize:Int):Void;

	/** 
	 * Gets the pool for components of type T with the specified component type ID. 
	 * @param componentTypeId The type ID of the components. 
	 * @return The component pool for type T. 
	 */
	function getPoolFor<T:IComponent>(componentTypeId:Int):IPool<T>;
}