package systemsrx.infrastructure.dependencies; /** * Builder for dependency bindings */ class BindingBuilder {

	var configuration:BindingConfiguration;

	public function new() {
		configuration = new BindingConfiguration();
	}

	public function asSingleton():BindingBuilder {
		configuration.asSingleton = true;
		return this;
	}

	public function asTransient():BindingBuilder {
		configuration.asSingleton = false;
		return this;
	}

	public function withName(name:String):BindingBuilder {
		configuration.withName = name;
		return this;
	}

	function build():BindingConfiguration {
		return configuration;
	}
}

class BindingBuilderTyped<T> extends BindingBuilder {
	public function new() {
		super();
	}

	public function toInstance<TTo:T>(instance:TTo):BindingBuilderTyped<T> {
		if (configuration.toMethod != null) {
			throw "Cannot use instance when a method has been provided already";
		}
		configuration.toInstance = instance;
		return this;
	}

	public function toMethod<TTo:T>(method:IDependencyResolver->TTo):BindingBuilderTyped<T> {
		if (configuration.toInstance != null) {
			throw "Cannot use method when an instance has been provided already";
		}
		configuration.toMethod = method;
		return this;
	}
}