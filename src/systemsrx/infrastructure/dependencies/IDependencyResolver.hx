package systemsrx.infrastructure.dependencies;

interface IDependencyResolver {/** * Resolve an instance of a type */ function resolve<T>(type:Class<T>):T; /** * Check if a type can be resolved */ function canResolve<T>(type:Class<T>):Bool;

}