package ecsrxe.groups;

import ecsrxe.groups.IGroup;
import ecsrxe.groups.EmptyGroup;

/** 
 * Group implementation. 
 * 
 * Hint: maybe consider using Group.Empty for better performance, unless you plan on changing the group afterwards. 
 */
@:keep
class Group implements IGroup {
	/** 
	 * Static readonly instance of an empty group for better performance. 
	 */
	public static final empty:IGroup = new EmptyGroup();

	/** 
	 * The component types that are required for an entity to belong to this group. 
	 */
	public var requiredComponents(default, null):Array<Class<Dynamic>>;

	/** 
	 * The component types that are excluded for an entity to belong to this group. 
	 */
	public var excludedComponents(default, null):Array<Class<Dynamic>>;

	/** 
	 * Creates a new Group with no required or excluded components. 
	 * 
	 * Hint: maybe consider using Group.Empty for better performance, unless you plan on changing the group afterwards. 
	 */
	public function new() {
		// В C# было: RequiredComponents = Array.Empty<Type>();
		// В Haxe используем пустой массив
		requiredComponents = [];
		// В C# было: ExcludedComponents = Array.Empty<Type>();
		// В Haxe используем пустой массив
		excludedComponents = [];
	}

	/** 
	 * Creates a new Group with the specified required components and no excluded components. 
	 * @param requiredComponents The component types that are required. 
	 */
	public function fromRequired(requiredComponents:Array<Class<Dynamic>>) {
		// В C# было: RequiredComponents = requiredComponents?.ToArray() ?? Array.Empty<Type>();
		// В Haxe используем тернарный оператор и проверку на null
		this.requiredComponents = (requiredComponents != null) ? requiredComponents.copy() : [];
		// В C# было: ExcludedComponents = Array.Empty<Type>();
		// В Haxe используем пустой массив
		this.excludedComponents = [];
	}

	/** 
	 * Creates a new Group with the specified required and excluded components. 
	 * @param requiredComponents The component types that are required. 
	 * @param excludedComponents The component types that are excluded. 
	 */
	public function fromRequiredAndExcluded(requiredComponents:Array<Class<Dynamic>>, excludedComponents:Array<Class<Dynamic>>) {
		// В C# было: RequiredComponents = requiredComponents?.ToArray() ?? Array.Empty<Type>();
		// В Haxe используем тернарный оператор и проверку на null
		this.requiredComponents = (requiredComponents != null) ? requiredComponents.copy() : [];
		// В C# было: ExcludedComponents = excludedComponents?.ToArray() ?? Array.Empty<Type>();
		// В Haxe используем тернарный оператор и проверку на null
		this.excludedComponents = (excludedComponents != null) ? excludedComponents.copy() : [];
	}
}