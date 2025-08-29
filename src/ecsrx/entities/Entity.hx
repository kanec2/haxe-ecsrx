package ecsrx.entities;

class Entity {
	public var id(default, null):Int;
	public var name(default, null):String;

	private var _components:Map<String, Dynamic> = new Map();

	public function new(id:Int, ?name:String) {
		this.id = id;
		this.name = name != null ? name : "";
	}

	public function addComponent<T>(component:T, ?componentName:String):Void {
		var name = componentName != null ? componentName : Type.getClassName(Type.getClass(component));
		_components.set(name, component);
	}

	public function getComponent<T>(componentClass:Class<T>):T {
		var name = Type.getClassName(componentClass);
		return _components.get(name);
	}

	public function hasComponent<T>(componentClass:Class<T>):Bool {
		var name = Type.getClassName(componentClass);
		return _components.exists(name);
	}

	public function removeComponent<T>(componentClass:Class<T>):Void {
		var name = Type.getClassName(componentClass);
		_components.remove(name);
	}
}