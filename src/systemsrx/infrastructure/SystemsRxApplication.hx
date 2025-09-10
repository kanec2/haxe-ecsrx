package systemsrx.infrastructure;

import systemsrx.executor.ISystemExecutor;
import systemsrx.events.IEventSystem;
import systemsrx.infrastructure.dependencies.IDependencyRegistry;
import systemsrx.infrastructure.dependencies.IDependencyResolver;
import systemsrx.infrastructure.plugins.ISystemsRxPlugin;
import systemsrx.systems.ISystem;
// Для работы со списками и итерациями
import haxe.ds.List;

/** * Abstract base class for SystemsRx applications */
@:abstract class SystemsRxApplication implements ISystemsRxApplication {
	public var systemExecutor(default, null):ISystemExecutor;
	public var eventSystem(default, null):IEventSystem;
	public var plugins(get, null):Array<ISystemsRxPlugin>;
	public var dependencyRegistry(get, null):IDependencyRegistry;
	public var dependencyResolver:IDependencyResolver;

	var _plugins:Array<ISystemsRxPlugin>;

	public var isRunning:Bool = false;

	public function new() {
		_plugins = [];
	}

	function get_plugins():Array<ISystemsRxPlugin> {
		return _plugins;
	}

	// Абстрактные методы, которые должны быть реализованы в подклассах
	public abstract function get_dependencyRegistry():IDependencyRegistry;

	public abstract function applicationStarted():Void; 
    /** * This starts the process of initializing the application */ 
    public function startApplication():Void {

		if (isRunning)
			return;
		isRunning = true;
		loadModules();
		loadPlugins();
		setupPlugins();
		bindSystems();
		dependencyResolver = dependencyRegistry.buildResolver(); // Предполагаемый метод
		resolveApplicationDependencies();
		startPluginSystems();
		startSystems();
		applicationStarted();
	} /** * This stops all systems */ 
    
    public function stopApplication():Void {

		if (!isRunning)
			return;
		isRunning = false;
		stopSystems();
	}

	/** * Load any modules that your application needs */
	function loadModules():Void {
		// В базовой реализации ничего не делаем
		// Подклассы могут переопределить этот метод
        dependencyRegistry.loadModule(new FrameworkModule());
	}

	/** * Load any plugins that your application needs */
	function loadPlugins():Void {
		// В базовой реализации ничего не делаем
		// Подклассы должны переопределить этот метод и вызвать registerPlugin
	}

	/** * Resolve any dependencies the application needs */
	function resolveApplicationDependencies():Void {
		systemExecutor = dependencyResolver.resolve(ISystemExecutor);
		eventSystem = dependencyResolver.resolve(IEventSystem);
	}

	/** * Bind any systems that the application will need */
	function bindSystems():Void {
		// Автоматическая привязка систем в рамках приложения
		// bindAllSystemsWithinApplicationScope();
	}

	function stopSystems():Void {
		// Создаем копию списка систем для безопасной итерации
		var allSystems = systemExecutor.systems.copy();
		for (system in allSystems) {
			systemExecutor.removeSystem(system);
		}
	}

	/** * Start any systems that the application will need */
	function startSystems():Void {
		// Автоматический запуск всех привязанных систем
		// startAllBoundSystems();
	}

	function setupPlugins():Void {
		for (plugin in _plugins) {
			plugin.setupDependencies(dependencyRegistry);
		}
	}

	function startPluginSystems():Void {
		for (plugin in _plugins) {
			var pluginSystems = plugin.getSystemsForRegistration(dependencyResolver);
			for (system in pluginSystems) {
				systemExecutor.addSystem(system);
			}
		}
	}

	/** * Register a given plugin within the application */
	function registerPlugin(plugin:ISystemsRxPlugin):Void {
		_plugins.push(plugin);
	}

    abstract function applicationStarted():Void;
}