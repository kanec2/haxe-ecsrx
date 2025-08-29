package examples;

import ecsrx.framework.FrameworkBuilder;
import ecsrx.framework.FrameworkConfiguration;
import ecsrx.plugins.CorePlugin;
import ecsrx.systems.examples.ExampleSetupSystem;
import ecsrx.systems.examples.ExampleReactToEntitySystem;

class SimpleGameExample {
	public static function createApplication():ecsrx.framework.IEcsRxApplication {
		var config = new FrameworkConfiguration();
		config.applicationName = "SimpleGame";
		return new FrameworkBuilder().withConfiguration(config).withPlugin(new CorePlugin()).build();
	}

	public static function setupSystems(application:ecsrx.framework.IEcsRxApplication):Void {
		// Регистрируем системы через DI
		/* var setupSystem = new ExampleSetupSystem(application.entityDatabase); 
			var reactSystem = new ExampleReactToEntitySystem(application.entityDatabase); 
			application.registerSystem(setupSystem); application.registerSystem(reactSystem); 
		 */
    }
}