package systemsrx.infrastructure;

package systemsrx.infrastructure;

import systemsrx.executor.ISystemExecutor;
import systemsrx.events.IEventSystem;
import systemsrx.infrastructure.dependencies.IDependencyRegistry;
import systemsrx.infrastructure.dependencies.IDependencyResolver;
import systemsrx.infrastructure.plugins.ISystemsRxPlugin;
// import для DI адаптеров
import systemsrx.haxeinjection.HaxeInjectionRegistry;
import systemsrx.haxeinjection.HaxeInjectionResolver;
// import для ServiceCollection и ServiceProvider из haxe-injection
import hx.injection.ServiceCollection;
import hx.injection.ServiceProvider;

interface ISystemsRxApplication {
	var systemExecutor(default, null):ISystemExecutor;
	var eventSystem(default, null):IEventSystem;
	var plugins(get, null):Array<ISystemsRxPlugin>;
	var dependencyRegistry(get, null):IDependencyRegistry;
	var dependencyResolver:IDependencyResolver;
	var isRunning:Bool;
	function startApplication():Void;
	function stopApplication():Void;
}