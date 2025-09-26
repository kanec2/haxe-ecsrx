package ecsrxe.lookups;

import ecsrxe.collections.entity.IEntityCollection;
import haxe.ds.IntMap;

/** 
 * Lookup for entity collections keyed by their id. 
 */
class CollectionLookup {
	final map:IntMap<IEntityCollection>;
	final list:Array<IEntityCollection>;

	public function new() {
		map = new IntMap<IEntityCollection>();
		list = [];
	}

	public function add(collection:IEntityCollection):Void {
		if (!map.exists(collection.id)) {
			map.set(collection.id, collection);
			list.push(collection);
		}
	}

	public function remove(id:Int):Bool {
		if (map.exists(id)) {
			var collection = map.get(id);
			map.remove(id);
			list.remove(collection);
			return true;
		}
		return false;
	}

	public function get(id:Int):IEntityCollection {
		if (map.exists(id)) {
			return map.get(id);
		}
		throw "Collection with id " + id + " not found";
	}

	public function contains(id:Int):Bool {
		return map.exists(id);
	}

	public function clear():Void {
		map.clear();
		list.resize(0);
	}

	public function toArray():Array<IEntityCollection> {
		return list.copy();
	}

	public function get_length():Int {
		return list.length;
	}

	public function getByIndex(index:Int):IEntityCollection {
		if (index < 0 || index >= list.length) {
			throw "Index out of bounds";
		}
		return list[index];
	}
}