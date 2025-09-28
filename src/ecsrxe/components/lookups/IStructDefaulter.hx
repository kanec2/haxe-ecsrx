
package ecsrxe.components.lookups; 
 
/** 
 * Interface for providing default values for struct types. 
 * This is used to determine if a component value is in its default state. 
 */ 
interface IStructDefaulter { 
 /** 
 * Gets the default value for a struct at the specified index. 
 * @param index The index of the struct. 
 * @return The default value. 
 */ 
 function getDefault(index:Int):Dynamic; 
 
 /** 
 * Checks if a value is the default value for a struct at the specified index. 
 * @param value The value to check. 
 * @param index The index of the struct. 
 * @return true if the value is the default, false otherwise. 
 */ 
 function isDefault<T>(value:T, index:Int):Bool; 
}