package ecsrxe.groups;

import ecsrxe.groups.IGroup;
#if (threads || sys)
import haxe.ds.Map; // Для Dictionary

#end

/** 
 * Represents an empty group with no required or excluded components. 
 * This is a singleton-like class for better performance when no components are needed. 
 */
@:keep // Чтобы класс не был удален DCE
class EmptyGroup implements IGroup {
	#if (threads || sys)
	/** 
	 * The component types that are required for an entity to belong to this group. 
	 * This is an empty array. 
	 */
	public var requiredComponents(default, null):Array<Class<Dynamic>> = [];

	/** 
	 * The component types that are excluded for an entity to belong to this group. 
	 * This is an empty array. 
	 */
	public var excludedComponents(default, null):Array<Class<Dynamic>> = [];
	#else
	// Заглушка для платформ без поддержки
	public var requiredComponents(default, null):Array<Class<Dynamic>> = [];
	public var excludedComponents(default, null):Array<Class<Dynamic>> = [];
	#end

	/** 
	 * Creates a new EmptyGroup. 
	 * In Haxe, this is a simple struct-like class with no constructor logic. 
	 */
	public function new() {
		// Нет логики в конструкторе, так как поля инициализируются inline
		// В C# это был readonly static field Array.Empty<Type>(), в Haxe используем []
	}
}