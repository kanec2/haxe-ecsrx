package ecsrxe.collections.events;

import ecsrxe.entities.IEntity;

/** 
 * Event structure for when an entity is added to or removed from a collection. 
 */
@:structInit
class CollectionEntityEvent /*implements IEquatable<CollectionEntityEvent>*/ {
	public var entity(default, null):IEntity;

	public function new(entity:IEntity) {
		this.entity = entity;
	}

	public function equals(other:CollectionEntityEvent):Bool {
		if (other == null)
			return false;
		return (entity == other.entity)
			|| (entity != null && other.entity != null && entity.equals != null && entity.equals(other.entity));
	}

	public function toString():String {
		return 'CollectionEntityEvent(entity: $entity)';
	}

	public function hashCode():Int {
		return (entity != null) ? entity.hashCode() : 0;
	}
}