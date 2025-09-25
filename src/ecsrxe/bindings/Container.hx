package ecsrx.bindings;

import haxe.ds.StringMap;

class Container implements IContainer {
	private var _bindings:StringMap<BindingInfo<Dynamic>> = new StringMap();
	private var _singletons:StringMap<Dynamic> = new StringMap();

	public function new() {}

	public function bind<T>():IBindingBuilder<T> {
		return new BindingBuilder<T>(this);
	}

	public function unbind<T>(type:Class<T>):Void {
		var key = Type.getClassName(type);
		_bindings.remove(key);
		_singletons.remove(key);
	}

	public function resolve<T>(type:Class<T>):T {
		var key = Type.getClassName(type);
		// Проверяем синглтон
		if (_singletons.exists(key)) {
			return _singletons.get(key);
		}
		// Проверяем биндинг
		if (_bindings.exists(key)) {
			var binding = _bindings.get(key);
			var instance = createInstance(binding, type);
			if (binding.isSingleton) {
				_singletons.set(key, instance);
			}
			return instance;
		}
		// Пытаемся создать экземпляр напрямую
		return createDirectInstance(type);
	}

	private function createInstance<T>(binding:BindingInfo<T>, type:Class<T>):T {
		if (binding.instance != null) {
			return binding.instance;
		}
		if (binding.factory != null) {
			return binding.factory();
		}
		if (binding.targetType != null) {
			return createDirectInstance(binding.targetType);
		}
		return createDirectInstance(type);
	}

	private function createDirectInstance<T>(type:Class<T>):T {
		// Простая реализация - в реальном DI контейнере нужно учитывать конструкторы
		return Type.createInstance(type, []);
	}

	public function hasBinding<T>(type:Class<T>):Bool {
		var key = Type.getClassName(type);
		return _bindings.exists(key) || _singletons.exists(key);
	}

	public function addBinding<T>(type:Class<T>, binding:BindingInfo<T>):Void {
		var key = Type.getClassName(type);
		_bindings.set(key, binding);
	}

	public function dispose():Void {
		_bindings.clear();
		_singletons.clear();
	}
}

class BindingInfo<T> {
	public var instance:T;
	public var targetType:Class<T>;
	public var factory:Void->T;
	public var isSingleton:Bool = false;
	public var condition:String->Bool;

	public function new() {}
}

class BindingBuilder<T> implements IBindingBuilder<T> {
	private var _container:Container;
	private var _binding:BindingInfo<T>;
	private var _type:Class<T>;

	public function new(container:Container) {
		this._container = container;
		this._binding = new BindingInfo();
	}

	public function to(instance:T):IBindingBuilder<T> {_binding.instance = instance; return this;}

	public function toType(type:Class<T>):IBindingBuilder<T> {
		_binding.targetType = type;
		return this;
	}

	public function toMethod(factory:Void->T):IBindingBuilder<T> {
		_binding.factory = factory;
		return this;
	}

	public function asSingleton():IBindingBuilder<T> {
		_binding.isSingleton = true;
		_container.addBinding(_type, _binding);
		return this;
	}

	public function asTransient():IBindingBuilder<T> {
		_binding.isSingleton = false;
		_container.addBinding(_type, _binding);
		return this;
	}

	public function when(condition:String->Bool):IBindingBuilder<T> {
		_binding.condition = condition;
		return this;
	}
}