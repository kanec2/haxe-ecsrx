package ecsrxe.lookups;

import ecsrxe.entities.IEntity;
import haxe.ds.Map;

/** 
 * Lookup for entities keyed by their id. 
 * Mimics the behavior of KeyedCollection<int, IEntity> from C#. 
 */
@:keep
class EntityLookup {
	// Карта для быстрого поиска по ключу (id)
	final map:Map<Int, IEntity>;
	// Массив для хранения элементов в порядке добавления и итерации
	final list:Array<IEntity>;

	public function new() {
		map = new Map<Int, IEntity>();
		list = [];
	}

	/** 
	 * Adds an item to the lookup. 
	 * @param item The item to add. 
	 */
	public function add(item:IEntity):Void {
		if (item == null) {
			throw "Item cannot be null";
		}

		var key = getKeyForItem(item);
		if (!map.exists(key)) {
			map.set(key, item);
			list.push(item);
		}
		// Если элемент с таким ключом уже существует, не добавляем дубликат
	}

	/** 
	 * Removes an item from the lookup by its key. 
	 * @param key The key of the item to remove. 
	 * @return True if the item was removed, false otherwise. 
	 */
	public function remove(key:Int):Bool {
		if (map.exists(key)) {
			var item = map.get(key);
			map.remove(key);
			list.remove(item);
			return true;
		}
		return false;
	}

	/** 
	 * Gets an item from the lookup by its key. 
	 * @param key The key of the item to get. 
	 * @return The item with the specified key. 
	 * @throws Exception if no item with the specified key exists. 
	 */
	public function get(key:Int):IEntity {
		if (map.exists(key)) {
			return map.get(key);
		}
		throw "Item with key " + key + " not found";
	}

	/** 
	 * Checks if the lookup contains an item with the specified key. 
	 * @param key The key to check for. 
	 * @return True if an item with the specified key exists, false otherwise. 
	 */
	public function contains(key:Int):Bool {
		return map.exists(key);
	}

	/** 
	 * Clears the lookup, removing all items. 
	 */
	public function clear():Void {
		map.clear();
		list.resize(0);
	}

	/** 
	 * Gets the number of items in the lookup. 
	 */
	public var count(get, null):Int;

	function get_count():Int {
		return list.length;
	}

	/** 
	 * Gets an item from the lookup by its index. 
	 * @param index The index of the item to get. 
	 * @return The item at the specified index. 
	 * @throws Exception if the index is out of bounds. 
	 */
	public function getByIndex(index:Int):IEntity {
		if (index < 0 || index >= list.length) {
			throw "Index out of bounds";
		}
		return list[index];
	}

	/** 
	 * Gets the key for the specified item. 
	 * This method is overridden in derived classes to extract the key from the item. 
	 * @param item The item to get the key for. 
	 * @return The key for the specified item. 
	 */
	function getKeyForItem(item:IEntity):Int {
		// В C# это был абстрактный метод protected abstract int GetKeyForItem(IEntity item);
		// В Haxe мы делаем его виртуальным и реализуем логику по умолчанию
		if (item == null) {
			throw "Item cannot be null";
		}
		// IEntity имеет свойство id
		return item.id;
	}

	/** 
	 * Returns an iterator over the items in the lookup. 
	 * This makes the lookup Iterable<IEntity>. 
	 */
	public function iterator():Iterator<IEntity> {
		return list.iterator();
	}

	/** 
	 * Converts the lookup to an array. 
	 * @return An array containing all items in the lookup. 
	 */
	public function toArray():Array<IEntity> {
		return list.copy();
	}
}