
package ecsrxe.components.lookups; 
 
import ecsrxe.components.IComponent; 
#if (threads || sys) 
import haxe.ds.Map; // Для Dictionary 
#end 
 
/** 
 * The Component Type Assigner interface is used to generate the internal lookup mappings 
 * for component types to ids. 
 * 
 * The default implementation provided in this framework will use reflection to find all 
 * IComponent implementations within the AppDomain and then register them arbitrary values 
 * so this may not be consistent between runs. 
 */ 
interface IComponentTypeAssigner { 
 /** 
 * Generates a mapping from component types to their assigned IDs. 
 * @return A read-only dictionary mapping component types to IDs. 
 */ 
 #if (threads || sys) 
 function generateComponentLookups():Map<Class<IComponent>, Int>; 
 #else 
 function generateComponentLookups():Dynamic; 
 #end 
}