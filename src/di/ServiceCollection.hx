package di;

class ServiceCollection {
	private var services:Map<String, Dynamic> = new Map();
	private var singletons:Map<String, Dynamic> = new Map();

	public function new() {}

	public function addSingleton<T>(interfaceName:String, implementation:T):ServiceCollection {
		singletons.set(interfaceName, implementation);
		return this;
	}

	public function addTransient<T>(interfaceName:String, factory:Void->T):ServiceCollection {
		services.set(interfaceName, factory);
		return this;
	}

	public function getService<T>(interfaceName:String):T {
		if (singletons.exists(interfaceName)) {
			return singletons.get(interfaceName);
		}
		if (services.exists(interfaceName)) {
			var factory:Void->T = services.get(interfaceName);
			return factory();
		}
		return null;
	}
}