package ecsrxe.collections.entity;

import ecsrxe.entities.IEntityFactory;
import ecsrxe.collections.entity.IEntityCollection;
import ecsrxe.collections.entity.EntityCollection;
import systemsrx.factories.IFactory;

/** 
 * Default implementation of IEntityCollectionFactory. 
 * Creates EntityCollection instances. 
 */
class DefaultEntityCollectionFactory implements IEntityCollectionFactory {
	final entityFactory:IEntityFactory;

	public function new(entityFactory:IEntityFactory) {
		this.entityFactory = entityFactory;
	}

	public function create(id:Int):IEntityCollection {
		return new EntityCollection(id, entityFactory);
	}
}