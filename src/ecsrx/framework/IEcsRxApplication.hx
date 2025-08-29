package ecsrx.framework;

import ecsrx.entities.IEntityDatabase;
import ecsrx.collections.ICollectionManager;
import ecsrx.systems.ISystem;
import ecsrx.plugins.IEcsRxPlugin;

interface IEcsRxApplication {
	var configuration:FrameworkConfiguration;
	var entityDatabase:IEntityDatabase;
	var collectionManager:ICollectionManager;
	var systems:Array<ISystem>;
	var plugins:Array<IEcsRxPlugin>;
	var isRunning:Bool;
	function startApplication():Void;
	function stopApplication():Void;
	function registerSystem(system:ISystem):Void;
	function unregisterSystem(system:ISystem):Void;
	function registerPlugin(plugin:IEcsRxPlugin):Void;
	function unregisterPlugin(plugin:IEcsRxPlugin):Void;
}