package tests.models;

/** 
 * A simple complex object for testing purposes. 
 */
@:structInit
class ComplexObject {
	public var id:Int;
	public var name:String;

	public function new(id:Int, name:String) {
		this.id = id;
		this.name = name;
	}

	public function toString():String {
		return 'ComplexObject(id: $id, name: $name)';
	}

	public function equals(other:ComplexObject):Bool {
		if (other == null)
			return false;
		return id == other.id && name == other.name;
	}

	/*public function hashCode():Int {
		return id * 31 + (name != null ? name.hashCode() : 0);
	}*/

	// ИСПРАВЛЕНИЕ: Реализация hashCode для String в Haxe
	public function hashCode():Int {
		// Простая хэш-функция для строки
		if (name == null)
			return id;

		var hash = 0;
		for (i in 0...name.length) {
			hash = ((hash << 5) - hash) + name.charCodeAt(i);
			hash = hash & hash; // Преобразуем в 32битный integer
		}
		return id * 31 + hash;
	}
}