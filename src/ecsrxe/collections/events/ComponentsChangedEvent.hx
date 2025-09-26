package ecsrxe.collections.events;

import ecsrxe.entities.IEntity;

/** 
 * Event structure for when components on an entity are changed. 
 */
@:structInit
class ComponentsChangedEvent /*implements IEquatable<ComponentsChangedEvent>*/ {
	public var entity(default, null):IEntity;
	public var componentTypeIds(default, null):Array<Int>;

	public function new(entity:IEntity, componentTypeIds:Array<Int>) {
		this.entity = entity;
		this.componentTypeIds = componentTypeIds;
	}

	public function equals(other:ComponentsChangedEvent):Bool {
		if (other == null)
			return false;
		return (entity == other.entity || (entity != null && other.entity != null && entity.equals != null && entity.equals(other.entity)))
			&& arraysEqual(componentTypeIds, other.componentTypeIds);
	}

	public function toString():String {
		return 'ComponentsChangedEvent(entity: $entity, componentTypeIds: ${componentTypeIds != null ? componentTypeIds.toString() : "null"})';
	}

	public function hashCode():Int {
		var result = (entity != null) ? (try entity.hashCode() catch (e:Dynamic) Std.string(entity).length) : 0;
		result = (result * 397) ^ (componentTypeIds != null ? arrayHashCode(componentTypeIds) : 0);
		return result;
	}

	// Вспомогательные функции для сравнения и хэширования массивов
	static function arraysEqual(a:Array<Int>, b:Array<Int>):Bool {
		if (a == null && b == null)
			return true;
		if (a == null || b == null)
			return false;
		if (a.length != b.length)
			return false;
		for (i in 0...a.length) {
			if (a[i] != b[i])
				return false;
		}
		return true;
	}

	static function arrayHashCode(arr:Array<Int>):Int {
		if (arr == null)
			return 0;
		var hash = 0;
		for (i in 0...arr.length) {
			hash = (hash * 31) + arr[i];
		}
		return hash;
	}
}