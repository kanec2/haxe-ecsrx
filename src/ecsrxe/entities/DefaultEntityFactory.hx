package ecsrxe.entities;

import systemsrx.pools.IIdPool;
import ecsrxe.components.database.IComponentDatabase;
import ecsrxe.components.lookups.IComponentTypeLookup;
import ecsrxe.entities.IEntity;
import ecsrxe.entities.Entity;
import systemsrx.factories.IFactory;

/** 
 * Default implementation of IEntityFactory 
 */
class DefaultEntityFactory implements IEntityFactory {
	public var idPool(default, null):IIdPool;
	public var componentDatabase(default, null):IComponentDatabase;
	public var componentTypeLookup(default, null):IComponentTypeLookup;

	public function new(idPool:IIdPool, componentDatabase:IComponentDatabase, componentTypeLookup:IComponentTypeLookup) {
		this.idPool = idPool;
		this.componentDatabase = componentDatabase;
		this.componentTypeLookup = componentTypeLookup;
	}

	public function getId(?id:Int):Int {
		if (id == null) {
			return idPool.allocateInstance();
		}

		idPool.allocateSpecificId(id);
		return id;
	}

	public function create(?id:Int):IEntity {
		if (id != null && id == 0) {
			throw "id must be null or > 0";
		}

		var usedId = getId(id);
		return new Entity(usedId, componentDatabase, componentTypeLookup);
	}

	public function destroy(entityId:Int):Void {
		idPool.releaseInstance(entityId);
	}
}