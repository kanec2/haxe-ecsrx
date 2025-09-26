package ecsrxe.groups;
 
import ecsrxe.entities.IEntity; 
 
/** 
 * Interface for systems or components that have a predicate to determine if they can process an entity. 
 */ 
interface IHasPredicate { 
 /** 
 * Determines if the system or component can process the given entity. 
 * @param entity The entity to check. 
 * @return true if the entity can be processed, false otherwise. 
 */ 
 function canProcessEntity(entity:IEntity):Bool; 
}