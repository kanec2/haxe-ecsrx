package ecsrxe.components.lookups;

#if (threads || sys)
import haxe.ds.Map; // Для Dictionary
import haxe.ds.ReadOnlyArray; // Для IReadOnlyList
#end
import ecsrxe.components.IComponent;
import ecsrxe.components.lookups.IComponentTypeLookup;

/** 
 * The Component Type Lookup implementation is responsible for looking up 
 * component ids for the types as well as vice versa. 
 */
@:keep // Чтобы класс не был удален DCE
class ComponentTypeLookup implements IComponentTypeLookup {
	#if (threads || sys)
	public var componentsByType(default, null):Map<Class<Dynamic>, Int>;
	public var componentsById(default, null):Map<Int, Class<Dynamic>>;
	public var componentStructLookups(default, null):Array<Bool>;
	public var componentDisposableLookups(default, null):Array<Bool>;
	public var allComponentTypeIds(default, null):Array<Int>;
	#end

	/** 
	 * Creates a new ComponentTypeLookup. 
	 * @param componentsByType The mapping from component types to their IDs. 
	 */
	public function new(componentsByType:Map<Class<Dynamic>, Int>) {
		#if (threads || sys)
		this.componentsByType = componentsByType;
		// ComponentsById = componentsByType.ToDictionary(x => x.Value, x => x.Key);
		this.componentsById = new Map<Int, Class<Dynamic>>();
		for (key => value in componentsByType) {
			componentsById.set(value, key);
		}

		// AllComponentTypeIds = componentsByType.Values.ToArray();
		this.allComponentTypeIds = [];
		for (value in componentsByType) {
			allComponentTypeIds.push(value);
		}

		// ComponentStructLookups = componentsByType.Keys
		// .Select(x => x.IsValueType)
		// .ToArray();
		this.componentStructLookups = [];
		for (key in componentsByType.keys()) {
			// В Haxe нет прямого эквивалента IsValueType
			// Но можно использовать Std.is для проверки на базовые типы
			// или предположить, что все Class<T> являются ссылочными типами
			// Для простоты, предположим, что все компоненты - ссылочные типы (false)
			// Если нужно точное поведение, потребуется макрос или метаданные
			componentStructLookups.push(false); // Заглушка: все компоненты считаются ссылочными
		}

		// ComponentDisposableLookups = componentsByType.Keys
		// .Select(x => x.GetInterfaces().Any(y => y == typeof(IDisposable)))
		// .ToArray();
		this.componentDisposableLookups = [];
		for (key in componentsByType.keys()) {
			// В Haxe нет прямого эквивалента GetInterfaces() и typeof(IDisposable)
			// Но можно использовать Std.is для проверки на IDisposable
			// или предположить, что все компоненты реализуют IDisposable
			// Для простоты, предположим, что все компоненты реализуют IDisposable (true)
			// Если нужно точное поведение, потребуется макрос или метаданные
			componentDisposableLookups.push(true); // Заглушка: все компоненты считаются disposable
		}
		#end
	}

	/** 
	 * Gets the component type ID for the specified type. 
	 * @param type The component type. 
	 * @return The ID of the component type. 
	 */
	public function getComponentTypeId(type:Class<Dynamic>):Int {
		#if (threads || sys)
		// try
		// {
		// return ComponentsByType[type];
		// }
		// catch (KeyNotFoundException ex) when (!typeof(IComponent).IsAssignableFrom(type))
		// {
		// throw new ArgumentException($"The supplied {nameof(type)} doesn't implement {nameof(IComponent)}. Additionally, there was no componentId was assigned to it. type = {type}", nameof(type), ex);
		// }

		// В Haxe нет try-catch с when clause, поэтому используем if
		if (componentsByType.exists(type)) {
			return componentsByType.get(type);
		} else {
			// Проверяем, реализует ли тип IComponent
			// В Haxe это делается через Std.is
			if (!Std.is(type, IComponent)) {
				throw "The supplied type doesn't implement IComponent. Additionally, there was no componentId assigned to it. type = "
					+ Type.getClassName(type);
			} else {
				// Тип реализует IComponent, но ID не найден
				throw "No componentId assigned to type " + Type.getClassName(type);
			}
		}
		#else
		return 0; // Заглушка
		#end
	}

	/** 
	 * Gets the component type for the specified type ID. 
	 * @param typeId The ID of the component type. 
	 * @return The component type. 
	 */
	public function getComponentType(typeId:Int):Class<Dynamic> {
		#if (threads || sys)
		// return ComponentsById[typeId];
		if (componentsById.exists(typeId)) {
			return componentsById.get(typeId);
		} else {
			throw "No component type found for typeId " + typeId;
		}
		#else
		return null; // Заглушка
		#end
	}

	/** 
	 * Checks if the component with the specified type ID is a struct. 
	 * @param componentTypeId The ID of the component type. 
	 * @return true if the component is a struct, false otherwise. 
	 * @remarks In Haxe, this might check if the type is a value type or has specific metadata. 
	 */
	public function isComponentStruct(componentTypeId:Int):Bool {
		#if (threads || sys)
		// return ComponentStructLookups[componentTypeId];
		if (componentTypeId >= 0 && componentTypeId < componentStructLookups.length) {
			return componentStructLookups[componentTypeId];
		} else {
			// Если индекс выходит за границы, возвращаем false (ссылочный тип по умолчанию)
			return false;
		}
		#else
		return false; // Заглушка
		#end
	}

	/** 
	 * Checks if the component with the specified type ID implements IDisposable. 
	 * @param componentTypeId The ID of the component type. 
	 * @return true if the component implements IDisposable, false otherwise. 
	 * @remarks In Haxe, this might check if the type implements a dispose() method. 
	 */
	public function isComponentDisposable(componentTypeId:Int):Bool {
		#if (threads || sys)
		// return ComponentDisposableLookups[componentTypeId];
		if (componentTypeId >= 0 && componentTypeId < componentDisposableLookups.length) {
			return componentDisposableLookups[componentTypeId];
		} else {
			// Если индекс выходит за границы, возвращаем true (все disposable по умолчанию)
			return true;
		}
		#else
		return true; // Заглушка
		#end
	}

	/** 
	 * Gets the mapping from component types to their IDs. 
	 * @return A read-only dictionary mapping types to IDs. 
	 */
	public function getComponentTypeMappings():Map<Class<Dynamic>, Int> {
		#if (threads || sys)
		// return ComponentsByType;
		return componentsByType;
		#else
		return null; // Заглушка
		#end
	}

	/** 
	 * Gets all component type IDs. 
	 */
	public var allComponentTypeIds(get, null):Array<Int>;

	function get_allComponentTypeIds():Array<Int> {
		#if (threads || sys)
		return allComponentTypeIds;
		#else
		return []; // Заглушка
		#end
	}
}