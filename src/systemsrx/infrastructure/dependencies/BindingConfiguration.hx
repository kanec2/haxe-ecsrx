package systemsrx.infrastructure.dependencies; 
/** * Configuration for dependency binding */ 
class BindingConfiguration {

	public var asSingleton:Bool = true;
	public var withName:String = null;
	public var toInstance:Dynamic = null;
	public var toMethod:IDependencyResolver->Dynamic = null;

	public function new() {}
}