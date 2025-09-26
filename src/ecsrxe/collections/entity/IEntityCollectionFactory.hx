package ecsrxe.collections.entity;

import systemsrx.factories.IFactoryWithArgument;
import systemsrx.factories.IFactory;
import ecsrxe.collections.entity.IEntityCollection;

/** 
 * Creates an entity collection for a given id 
 * 
 * This is meant to be replaceable so you can create your own implementation and replace for using 
 * your own entity collection implementations 
 */
interface IEntityCollectionFactory extends IFactoryWithArgument<Int, IEntityCollection> {
	// Наследует Create(id:Int) от IFactory<Int, IEntityCollection>
}