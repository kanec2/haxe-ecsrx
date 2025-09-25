package ecsrxe.components.lookups;

import ecsrxe.components.IComponent;

/** 
 * The Component Type Lookup interface is responsible for looking up 
 * component ids for the types as well as vice versa. 
 */
interface IComponentTypeLookup {
	/** 
	 * Gets all component type IDs. 
	 */
	var allComponentTypeIds(get, null):Array<Int>;

	/** 
	 * Gets the mapping from component types to their IDs. 
	 * @return A read-only dictionary mapping types to IDs. 
	 */
	function getComponentTypeMappings():Map<Class<IComponent>, Int>;

	/** 
	 * Gets the component type ID for the specified type. 
	 * @param type The component type. 
	 * @return The ID of the component type. 
	 */
	function getComponentTypeId(type:Class<IComponent>):Int;

	/** 
	 * Gets the component type for the specified type ID. 
	 * @param typeId The ID of the component type. 
	 * @return The component type. 
	 */
	function getComponentType(typeId:Int):Class<IComponent>;

	/** 
	 * Checks if the component with the specified type ID is a struct. 
	 * @param componentTypeId The ID of the component type. 
	 * @return true if the component is a struct, false otherwise. 
	 * @remarks In Haxe, this might check if the type is a value type or has specific metadata. 
	 */
	function isComponentStruct(componentTypeId:Int):Bool;

	/** 
	 * Checks if the component with the specified type ID implements IDisposable. 
	 * @param componentTypeId The ID of the component type. 
	 * @return true if the component implements IDisposable, false otherwise. 
	 * @remarks In Haxe, this might check if the type implements a dispose() method. 
	 */
	function isComponentDisposable(componentTypeId:Int):Bool;

	// В Haxe геттер для allComponentTypeIds
	function get_allComponentTypeIds():Array<Int>;
}