package ecsrxe.components;

/** 
 * A container for isolated contextual data on an entity, should never contain logic. 
 * Components should contain pure data which is passed around to different systems. 
 * If you also need to dispose on data inside your component i.e ReactiveProperty vars 
 * then just implement IDisposable as well and they will be auto disposed when the entity 
 * disposes 
 */
interface IComponent {
	// This is a marker interface with no methods
}