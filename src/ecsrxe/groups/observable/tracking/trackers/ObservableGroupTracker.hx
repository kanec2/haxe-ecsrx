package ecsrxe.groups.observable.tracking.events;

import ecsrxe.entities.IEntity;
import ecsrxe.groups.observable.tracking.types.GroupActionType;

/** 
 * Event structure for when an entity's group state changes. 
 * @param Entity The entity that changed state. 
 * @param GroupActionType The type of action that occurred. 
 */
@:structInit
class EntityGroupStateChanged /*implements IEquatable<EntityGroupStateChanged>*/ {
	/** 
	 * The entity that changed state. 
	 */
	public var entity(default, null):IEntity;

	/** 
	 * The type of action that occurred. 
	 */
	public var groupActionType(default, null):GroupActionType;

	/** 
	 * Creates a new EntityGroupStateChanged event. 
	 * @param entity The entity that changed state. 
	 * @param groupActionType The type of action that occurred. 
	 */
	public function new(entity:IEntity, groupActionType:GroupActionType) {
		this.entity = entity;
		this.groupActionType = groupActionType;
	}

	/** 
	 * Checks if this EntityGroupStateChanged is equal to another EntityGroupStateChanged. 
	 * @param other The other EntityGroupStateChanged to compare to. 
	 * @return true if the events are equal, false otherwise. 
	 */
	public function equals(other:EntityGroupStateChanged):Bool {
		if (other == null)
			return false;
		// В C# было: return Equals(Entity, other.Entity) && GroupActionType == other.GroupActionType;
		// В Haxe используем == для простых типов и equals() для объектов, если они есть
		return (entity == other.entity || (entity != null && other.entity != null && entity.equals != null && entity.equals(other.entity)))
			&& (groupActionType == other.groupActionType);
	}

	/** 
	 * Checks if this EntityGroupStateChanged is equal to another object. 
	 * @param obj The other object to compare to. 
	 * @return true if the objects are equal, false otherwise. 
	 */
	public function equalsObj(obj:Dynamic):Bool {
		// В C# было: return obj is EntityGroupStateChanged other && Equals(other);
		if (obj == null)
			return false;
		// Проверяем, является ли obj экземпляром EntityGroupStateChanged
		// В Haxe это делается через Std.is
		if (Std.is(obj, EntityGroupStateChanged)) {
			var other:EntityGroupStateChanged = cast obj;
			return equals(other);
		}
		return false;
	}

	/** 
	 * Gets the hash code for this EntityGroupStateChanged. 
	 * @return The hash code. 
	 */
	public function hashCode():Int {
		// В C# было:
		// unchecked
		// {
		// return ((Entity != null ? Entity.GetHashCode() : 0) * 397) ^ (int)GroupActionType;
		// }
		// В Haxe:
		var entityHash = 0;
		if (entity != null) {
			// Пытаемся использовать метод hashCode объекта, если он есть
			if (Reflect.hasField(entity, "hashCode") && Reflect.isFunction(Reflect.field(entity, "hashCode"))) {
				try {
					entityHash = Reflect.callMethod(entity, Reflect.field(entity, "hashCode"), []);
				} catch (e:Dynamic) {
					// Если hashCode бросил исключение, используем простой хэш
					entityHash = Std.string(entity).length; // Простая замена: длина строки
				}
			} else {
				// Если метода hashCode нет, используем длину строки как простой хэш
				entityHash = Std.string(entity).length;
			}
		}
		// unchecked в C#:
		// return ((entityHash * 397) ^ (int)groupActionType);
		// В Haxe GroupActionType это Int, так что просто используем его значение
		return ((entityHash * 397) ^ groupActionType);
	}

	/** 
	 * Returns a string representation of the EntityGroupStateChanged. 
	 * @return A string representation. 
	 */
	public function toString():String {
		// В C# было: override string ToString()
		return 'EntityGroupStateChanged(entity: $entity, groupActionType: $groupActionType)';
	}
}