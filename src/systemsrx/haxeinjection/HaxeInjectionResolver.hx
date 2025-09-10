package systemsrx.haxeinjection;

import systemsrx.infrastructure.dependencies.IDependencyResolver;
import hx.injection.ServiceProvider;

class HaxeInjectionResolver implements IDependencyResolver {
	var serviceProvider:ServiceProvider;

	public function new(serviceProvider:ServiceProvider) {
		this.serviceProvider = serviceProvider;
	}

	public function resolve<T>(type:Class<T>):T {
		return serviceProvider.getService(type);
	}

	public function canResolve<T>(type:Class<T>):Bool {
		// haxe-injection doesn't have direct canResolve method
		// We'll try to resolve and catch exceptions
		try {
			var instance = serviceProvider.getService(type);
			return instance != null;
		} catch (e:Dynamic) {
			return false;
		}
	}
}