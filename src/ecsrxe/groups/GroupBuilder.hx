package ecsrxe.groups;

import ecsrxe.components.IComponent;
import ecsrxe.entities.IEntity;
import ecsrxe.groups.IGroup;
import ecsrxe.groups.Group;
import ecsrxe.groups.GroupWithPredicate;
#if (threads || sys)
import haxe.ds.List; // Для List<Type>

#end

/** 
 * Builder for creating groups with a fluent API. 
 */
@:keep
class GroupBuilder {
	#if (threads || sys)
	var withComponents:List<Class<Dynamic>>;
	var withoutComponents:List<Class<Dynamic>>;
	var predicate:IEntity->Bool;
	#end

	public function new() {
		#if (threads || sys)
		withComponents = new List<Class<Dynamic>>();
		withoutComponents = new List<Class<Dynamic>>();
		#end
	}

	/** 
	 * Creates a new GroupBuilder instance. 
	 * @return A new GroupBuilder. 
	 */
	public function create():GroupBuilder {
		#if (threads || sys)
		withComponents = new List<Class<Dynamic>>();
		withoutComponents = new List<Class<Dynamic>>();
		#end
		return this;
	}

	/** 
	 * Adds a component type to the required components list. 
	 * @typeparam T The component type to add (must implement IComponent). 
	 * @return This GroupBuilder instance for chaining. 
	 */
	public function withComponent<T:IComponent>(componentType:Class<T>):GroupBuilder {
		#if (threads || sys)
		withComponents.add(componentType);
		#end
		return this;
	}

	/** 
	 * Adds a component type to the excluded components list. 
	 * @typeparam T The component type to exclude (must implement IComponent). 
	 * @return This GroupBuilder instance for chaining. 
	 */
	public function withoutComponent<T:IComponent>(componentType:Class<T>):GroupBuilder {
		#if (threads || sys)
		withoutComponents.add(componentType);
		#end
		return this;
	}

	/** 
	 * Adds a struct component type to the required components list. 
	 * @typeparam T The struct component type to add (must implement IComponent). 
	 * @return This GroupBuilder instance for chaining. 
	 * @remarks In Haxe, this is the same as withComponent<T>(). 
	 */
	public function withStructComponent<T:IComponent>(componentType:Class<T>):GroupBuilder {
		#if (threads || sys)
		// В Haxe нет различия между class и struct для компонентов
		// Поэтому просто вызываем withComponent
		return withComponent(componentType);
		#else
		return this;
		#end
	}

	/** 
	 * Adds a struct component type to the excluded components list. 
	 * @typeparam T The struct component type to exclude (must implement IComponent). 
	 * @return This GroupBuilder instance for chaining. 
	 * @remarks In Haxe, this is the same as withoutComponent<T>(). 
	 */
	public function withoutStructComponent<T:IComponent>(componentType:Class<T>):GroupBuilder {
		#if (threads || sys)
		// В Haxe нет различия между class и struct для компонентов
		// Поэтому просто вызываем withoutComponent
		return withoutComponent(componentType);
		#else
		return this;
		#end
	}

	/** 
	 * Sets a predicate for the group. 
	 * @param predicate The predicate to set. 
	 * @return This GroupBuilder instance for chaining. 
	 */
	public function withPredicate(predicate:IEntity->Bool):GroupBuilder {
		#if (threads || sys)
		this.predicate = predicate;
		#end
		return this;
	}

	/** 
	 * Builds the group. 
	 * @return The built group. 
	 */
	public function build():IGroup {
		#if (threads || sys)
		// Преобразуем List в Array для передачи в конструкторы Group
		var withComponentsArray = withComponents.toArray();
		var withoutComponentsArray = withoutComponents.toArray();

		return predicate != null ? new GroupWithPredicate(predicate, withComponentsArray,
			withoutComponentsArray) : new Group(withComponentsArray, withoutComponentsArray);
		#else
		return new Group([], []); // Заглушка
		#end
	}
}