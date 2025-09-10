package systemsrx.infrastructure.dependencies;

/** * This represents a cross platform DI module which contains * contextual bindings */
interface IDependencyModule {
	/** * The entry point where you can setup all your binding config */
	function setup(registry:IDependencyRegistry):Void;
}