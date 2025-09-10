package systemsrx.haxeinjection;

import systemsrx.infrastructure.dependencies.IDependencyRegistry;
import hx.injection.ServiceCollection;
import hx.injection.ServiceProvider;

class HaxeInjectionRegistry implements IDependencyRegistry {
	var serviceCollection:ServiceCollection;
	var serviceProvider:ServiceProvider;

	public function new(serviceCollection:ServiceCollection, serviceProvider:ServiceProvider) {
		this.serviceCollection = serviceCollection;
		this.serviceProvider = serviceProvider;
	}

	public function bind<T>(interfaceType:Class<T>, implementationType:Class<T>):Void {
		serviceCollection.addSingleton(interfaceType, implementationType);
	}

	public function bindInstance<T>(type:Class<T>, instance:T):Void {
		serviceCollection.addService(type, instance);
	}
}