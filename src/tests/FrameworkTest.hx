package tests;

import ecsrx.framework.EcsRxApplication;
import ecsrx.framework.FrameworkConfiguration;

class FrameworkTest {
	public static function runTests():Void {
		testBasicApplication();
		testSystemRegistration();
		testPluginRegistration();
	}

	private static function testBasicApplication():Void {
		var config = new FrameworkConfiguration();
		config.applicationName = "TestApp";
		var app = new EcsRxApplication(config);
		trace("Application created: " + (app != null));
		trace("Entity database created: " + (app.entityDatabase != null));
		trace("Collection manager created: " + (app.collectionManager != null));
		app.dispose();
	}

	private static function testSystemRegistration():Void {
		var app = new EcsRxApplication();
		// var system = new ExampleSetupSystem(app.entityDatabase);
		// app.registerSystem(system);
		trace("Systems registered: " + app.systems.length);
		app.dispose();
	}

	private static function testPluginRegistration():Void {
		var app = new EcsRxApplication();
		var plugin = new ecsrx.plugins.CorePlugin();
		app.registerPlugin(plugin);
		trace("Plugins registered: " + app.plugins.length);
		app.dispose();
	}
}