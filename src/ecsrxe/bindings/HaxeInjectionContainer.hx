package ecsrx.bindings;

import com.uking.injector.Injector;
import com.uking.injector.binding.IBinding;

class HaxeInjectionContainer implements IContainer {
	private var _injector:Injector;

	public function new() {
		this._injector = new Injector();
	}

	public function bind<T>():IBindingBuilder<T> {
		return new HaxeInjectionBindingBuilder<T>(_injector);
	}

	public function unbind<T>(type:Class<T>):Void {
		// haxe-injection не поддерживает прямое удаление биндингов
		// Можно реализовать через кастомную обертку
	}

	public function resolve<T>(type:Class<T>):T {
		return _injector.getInstance(type);
	}

	public function hasBinding<T>(type:Class<T>):Bool {
		// Проверка наличия биндинга
		try {
			_injector.getInstance(type);
			return true;
		} catch (e:Dynamic) {
			return false;
		}
	}

	public function dispose():Void {
		// Очистка injector
		_injector = null;
	}

	public function getInjector():Injector {
		return _injector;
	}
}

class HaxeInjectionBindingBuilder<T> implements IBindingBuilder<T> {
	private var _injector:Injector;
	private var _bindingType:Class<T>;
	private var _isSingleton:Bool = false;

	public function new(injector:Injector) {
		this._injector = injector;
	}

	public function to(instance:T):IBindingBuilder<T> {_injector.map(_bindingType).toValue(instance); return this;}

	public function toType(type:Class<T>):IBindingBuilder<T> {
		if (_isSingleton) {
			_injector.map(_bindingType).toSingleton(type);
		} else {
			_injector.map(_bindingType).toType(type);
		}
		return this;
	}

	public function toMethod(factory:Void->T):IBindingBuilder<T> {
		_injector.map(_bindingType).toProvider(factory);
		return this;
	}

	public function asSingleton():IBindingBuilder<T> {
		_isSingleton = true;
		return this;
	}

	public function asTransient():IBindingBuilder<T> {
		_isSingleton = false;
		return this;
	}

	public function when(condition:String->Bool):IBindingBuilder<T> {
		// haxe-injection не поддерживает условные биндинги напрямую
		// Можно реализовать через кастомные провайдеры
		return this;
	}
}