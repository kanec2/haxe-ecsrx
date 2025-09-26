package ecsrxe.collections.entity;

/** 
 * Interface for a collection that notifies about both entity and component changes. 
 */
interface INotifyingCollection extends INotifyingEntityCollection extends INotifyingEntityComponentChanges {
	// Наследует все методы и свойства от обоих интерфейсов
}