package systemsrx.infrastructure.dependencies;

interface IDependencyRegistry {/** * Register a type mapping (typically singleton) */ function bind<T>(interfaceType:Class<T>,
	implementationType:Class<T>):Void; /** * Register a singleton instance */ function bindInstance<T>(type:Class<T>, instance:T):Void;

}