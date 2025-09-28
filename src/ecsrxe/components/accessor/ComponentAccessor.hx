package ecsrxe.components.accessor;

import ecsrxe.entities.IEntity;
import ecsrxe.components.IComponent;
import ecsrxe.components.accessor.IComponentAccessor;
import ecsrxe.components.accessor.Ref;

/** 
 * Represents an optimised way to interact with a component type on an entity. 
 * 
 * In most cases you can just use the provided extension methods on IEntity, however for 
 * optimisations purposes this provides you a streamlined way to caching the component 
 * type id and relaying calls through to the underlying entity. 
 * @typeparam T The type of the component. 
 */
@:keep // Чтобы класс не был удален DCE
class ComponentAccessor<T:IComponent> implements IComponentAccessor<T> {
	/** 
	 * Gets the component type ID for the component type T. 
	 */
	public var componentTypeId(default, null):Int;

	/** 
	 * Creates a new ComponentAccessor. 
	 * @param componentTypeTypeId The component type ID for the component type T. 
	 */
	public function new(componentTypeTypeId:Int) {
		this.componentTypeId = componentTypeTypeId;
	}

	/** 
	 * Checks if the entity has a component of type T. 
	 * @param entity The entity to check. 
	 * @return true if the entity has the component, false otherwise. 
	 */
	public function has(entity:IEntity):Bool {
		return entity.hasComponent(componentTypeId);
	}

	/** 
	 * Gets the component of type T from the entity. 
	 * @param entity The entity to get the component from. 
	 * @return The component of type T. 
	 * @throws Exception if the entity does not have the component. 
	 */
	public function get(entity:IEntity):T {
		// В C# было: return (T)entity.GetComponent(ComponentTypeId);
		// В Haxe используем приведение типов cast
		var component:IComponent = entity.getComponent(componentTypeId);
		if (component == null) {
			throw "Entity does not have component of type " + componentTypeId;
		}
		return cast component;
	}

	/** 
	 * Removes the component of type T from the entity. 
	 * @param entity The entity to remove the component from. 
	 */
	public function remove(entity:IEntity):Void {
		// В C# было: entity.RemoveComponents(ComponentTypeId);
		// В Haxe используем removeComponents с массивом ID
		entity.removeComponents([componentTypeId]);
	}

	/** 
	 * Tries to get the component of type T from the entity. 
	 * @param entity The entity to get the component from. 
	 * @param component The component of type T, if found. 
	 * @return true if the component was found, false otherwise. 
	 */
	public function tryGet(entity:IEntity, component:Ref<T>):Bool {
		if (has(entity)) {
			// В C# было: component = Get(entity);
			// В Haxe используем component.value = get(entity)
			component.value = get(entity);
			return true;
		}

		// В C# было: component = default;
		// В Haxe используем null для значений по умолчанию
		component.value = null;
		return false;
	}
}