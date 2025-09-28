package ecsrxe.components.database;

#if (threads || sys)
import hx.concurrent.lock.Semaphore; // Для синхронизации
#end
import ecsrxe.components.IComponent;
import ecsrxe.components.pools.IComponentPool;
import ecsrxe.components.lookups.IComponentTypeLookup;
import ecsrxe.pools.IPool;

/** 
 * Component database implementation. 
 * Acts as a basic memory block for components of a specific type. 
 * This helps speed up access when you want components of the same type. 
 */
@:keep // Чтобы класс не был удален DCE
class ComponentDatabase implements IComponentDatabase {
	#if (threads || sys)
	final semaphore:Semaphore; // Используем Semaphore как Mutex

	#end
	public var defaultExpansionAmount(default, null):Int;
	public var componentTypeLookup(default, null):IComponentTypeLookup;

	public var componentData(default, null):Array<IComponentPool<Dynamic>>; // В Haxe Array вместо IComponentPool[]

	public function new(componentTypeLookup:IComponentTypeLookup, defaultExpansionSize:Int = 100) {
		#if (threads || sys)
		// Бинарный семафор для взаимного исключения (Mutex)
		semaphore = new Semaphore(1);
		#end

		this.componentTypeLookup = componentTypeLookup;
		this.defaultExpansionAmount = defaultExpansionSize;
		initialize();
	}

	public function createPoolFor(type:Class<Dynamic>, initialSize:Int):IComponentPool<Dynamic> {
		#if (threads || sys)
		semaphore.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;
		var result:IComponentPool<Dynamic> = null;

		try {
			// В C# использовался typeof(ComponentPool<>).MakeGenericType(typeArgs) и Activator.CreateInstance
			// В Haxe нет runtime рефлексии для создания обобщенных типов
			// Поэтому создаем пул напрямую
			// Предполагаем, что ComponentPool<T> реализован как ComponentPool<Dynamic> с явным приведением типов
			result = new ecsrxe.components.pools.ComponentPool<Dynamic>(initialSize);
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		semaphore.release();
		#end

		// Если была ошибка во время создания пула, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}

		return result;
	}

	public function initialize():Void {
		#if (threads || sys)
		semaphore.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;

		try {
			var componentTypes = componentTypeLookup.getComponentTypeMappings().toArray(); // В Haxe Map.toArray() возвращает Array<{key:K, value:V}>
			var componentCount = componentTypes.length;
			componentData = []; // В Haxe new Array<IComponentPool<Dynamic>>() или []

			for (i in 0...componentCount) {
				// В C# было componentTypes[i].Key, в Haxe это componentTypes[i].key
				var componentType = componentTypes[i].key; // Class<Dynamic> в Haxe вместо Type в C#
				componentData.push(createPoolFor(componentType, defaultExpansionAmount));
			}
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		semaphore.release();
		#end

		// Если была ошибка во время инициализации, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}
	}

	public function getPoolFor<T:IComponent>(componentTypeId:Int):IComponentPool<T> {
		#if (threads || sys)
		semaphore.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;
		var result:IComponentPool<T> = null;

		try {
			// В C# было (IComponentPool<T>) ComponentData[componentTypeId]
			// В Haxe используем cast для приведения типа
			result = cast componentData[componentTypeId];
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		semaphore.release();
		#end

		// Если была ошибка во время получения пула, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}

		return result;
	}

	public function get<T:IComponent>(componentTypeId:Int, allocationIndex:Int):T {
		#if (threads || sys)
		semaphore.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;
		var result:T = null;

		try {
			var componentPool:IComponentPool<T> = getPoolFor(componentTypeId);
			// В C# было componentPool.Components[allocationIndex]
			// В Haxe предполагаем, что у IComponentPool<T> есть метод getComponent(index:Int):T
			// или свойство components:Array<T>
			result = componentPool.get(allocationIndex); // Используем get() вместо []
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		semaphore.release();
		#end

		// Если была ошибка во время получения компонента, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}

		return result;
	}

	public function getRef<T:IComponent>(componentTypeId:Int, allocationIndex:Int):T {
		#if (threads || sys)
		semaphore.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;
		var result:T = null;

		try {
			var componentPool:IComponentPool<T> = getPoolFor(componentTypeId);
			// В C# было ref componentPool.Components[allocationIndex]
			// В Haxe нет прямого эквивалента ref, но можно вернуть ссылку на объект
			// или использовать обертку Ref<T>
			// Для простоты, возвращаем сам компонент
			result = componentPool.get(allocationIndex); // Используем get() вместо []
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		semaphore.release();
		#end

		// Если была ошибка во время получения ссылки на компонент, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}

		return result;
	}

	public function getComponents<T:IComponent>(componentTypeId:Int):Array<T> {
		#if (threads || sys)
		semaphore.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;
		var result:Array<T> = null;

		try {
			// В C# было GetPoolFor<T>(componentTypeId).Components
			// В Haxe предполагаем, что у IComponentPool<T> есть свойство components:Array<T>
			var componentPool:IComponentPool<T> = getPoolFor(componentTypeId);
			result = componentPool.components; // Используем свойство components
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		semaphore.release();
		#end

		// Если была ошибка во время получения компонентов, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}

		return result;
	}

	public function set<T:IComponent>(componentTypeId:Int, allocationIndex:Int, component:T):Void {
		#if (threads || sys)
		semaphore.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;

		try {
			var componentPool:IComponentPool<T> = getPoolFor(componentTypeId);
			// В C# было componentPool.Components[allocationIndex] = component
			// В Haxe предполагаем, что у IComponentPool<T> есть метод setComponent(index:Int, component:T):Void
			// или свойство components:Array<T>
			componentPool.set(allocationIndex, component); // Используем set() вместо []
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		semaphore.release();
		#end

		// Если была ошибка во время установки компонента, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}
	}

	public function remove(componentTypeId:Int, allocationIndex:Int):Void {
		#if (threads || sys)
		semaphore.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;

		try {
			// В C# было ComponentData[componentTypeId].Release(allocationIndex)
			// В Haxe предполагаем, что у IComponentPool<Dynamic> есть метод release(index:Int):Void
			componentData[componentTypeId].release(allocationIndex);
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		semaphore.release();
		#end

		// Если была ошибка во время удаления компонента, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}
	}

	public function allocate(componentTypeId:Int):Int {
		#if (threads || sys)
		semaphore.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;
		var result:Int = 0;

		try {
			// В C# было ComponentData[componentTypeId].Allocate()
			// В Haxe предполагаем, что у IComponentPool<Dynamic> есть метод allocate():Int
			result = componentData[componentTypeId].allocate();
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		semaphore.release();
		#end

		// Если была ошибка во время выделения компонента, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}

		return result;
	}

	public function preAllocateComponents(componentTypeId:Int, allocationSize:Int):Void {
		#if (threads || sys)
		semaphore.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;

		try {
			// В C# было ComponentData[componentTypeId].Expand(allocationSize)
			// В Haxe предполагаем, что у IComponentPool<Dynamic> есть метод expand(size:Int):Void
			componentData[componentTypeId].expand(allocationSize);
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		semaphore.release();
		#end

		// Если была ошибка во время предварительного выделения компонентов, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}
	}
}