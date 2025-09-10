package systemsrx.infrastructure.plugins;

import systemsrx.infrastructure.dependencies.IDependencyRegistry;
import systemsrx.infrastructure.dependencies.IDependencyResolver;
import systemsrx.systems.ISystem;

interface ISystemsRxPlugin {
	var name:String;
	var version:String;
	function setupDependencies(registry:IDependencyRegistry):Void;
	function getSystemsForRegistration(resolver:IDependencyResolver):Array<ISystem>;
}