package ecsrx.framework;

import ecsrx.entities.EntityDatabase;
import ecsrx.collections.CollectionManager;
import ecsrx.systems.ISystem;
import ecsrx.plugins.IEcsRxPlugin;
import rx.Subject;
import ecsrx.di.ServiceContainer;
import hx.injection.ServiceProvider;
using hx.injection.ServiceExtensions;

class EcsRxApplication implements IEcsRxApplication {
    public var configuration: FrameworkConfiguration;
    public var entityDatabase: ecsrx.entities.IEntityDatabase;
    public var collectionManager: ecsrx.collections.ICollectionManager;
    public var systems: Array<ISystem>;
    public var plugins: Array<IEcsRxPlugin>;
    public var isRunning: Bool = false;
    public var serviceContainer: ServiceContainer;

    private var _applicationStartedSubject: Subject<IEcsRxApplication>;
    private var _applicationStoppedSubject: Subject<IEcsRxApplication>;

    public function new(?config: FrameworkConfiguration) {
        this.configuration = config != null ? config : new FrameworkConfiguration();
        this.systems = [];
        this.plugins = [];
        this.serviceContainer = new ServiceContainer();
        // Инициализация основных компонентов 
        this.entityDatabase = new EntityDatabase();
        this.collectionManager = new CollectionManager(entityDatabase);
        _applicationStartedSubject = Subject.create();
        _applicationStoppedSubject = Subject.create();
        // Регистрируем основные сервисы в контейнере 
        //setupDefaultServices();
    }

    private function setupDefaultServices(): Void {
        serviceContainer.registerSingleton(ecsrx.entities.IEntityDatabase, entityDatabase);
        serviceContainer.registerSingleton(ecsrx.collections.ICollectionManager, collectionManager);
        serviceContainer.registerSingleton(IEcsRxApplication, this);
        serviceContainer.registerSingleton(ServiceContainer, serviceContainer);
    }

    public function startApplication(): Void {
        if (isRunning) return;
        // Вызываем beforeApplicationStarts для всех плагинов 
        for (plugin in plugins) {
            try {
                plugin.beforeApplicationStarts(this);
            } catch (e: Dynamic) {
                trace('Error in plugin ${plugin.pluginName} beforeApplicationStarts: $e');
            }
        }
        // Запускаем все системы 
        for (system in systems) {
            if (system.enabled) {
                try {
                    system.startSystem();
                } catch (e: Dynamic) {
                    trace('Error starting system ${system.systemName}: $e');
                }
            }
        }
        isRunning = true;
        _applicationStartedSubject.on_next(this);
        // Вызываем afterApplicationStarts для всех плагинов 
        for (plugin in plugins) {
            try {
                plugin.afterApplicationStarts(this);
            } catch (e: Dynamic) {
                trace('Error in plugin ${plugin.pluginName} afterApplicationStarts: $e');
            }
        }
    }

    public function stopApplication(): Void {
        if (!isRunning) return;
        // Вызываем beforeApplicationStops для всех плагинов 
        for (plugin in plugins) {
            try {
                plugin.beforeApplicationStops(this);
            } catch (e: Dynamic) {
                trace('Error in plugin ${plugin.pluginName} beforeApplicationStops: $e');
            }
        }
        // Останавливаем все системы в обратном порядке 
        var reversedSystems = systems.copy();
        reversedSystems.reverse();
        for (system in reversedSystems) {
            if (system.enabled) {
                try {
                    system.stopSystem();
                } catch (e: Dynamic) {
                    trace('Error stopping system ${system.systemName}: $e');
                }
            }
        }
        isRunning = false;
        _applicationStoppedSubject.on_next(this);
        // Вызываем afterApplicationStops для всех плагинов 
        for (plugin in plugins) {
            try {
                plugin.afterApplicationStops(this);
            } catch (e: Dynamic) {
                trace('Error in plugin ${plugin.pluginName} afterApplicationStops: $e');
            }
        }
    }

    public function registerSystem(system: ISystem): Void {
        if (!systems.contains(system)) {
            systems.push(system);
            // Сортируем по приоритету (по возрастанию) 
            systems.sort((a, b) -> a.priority - b.priority);
            // Если приложение запущено и система включена, запускаем её немедленно 
            if (isRunning && system.enabled && configuration.startSystemsImmediately) {
                try {
                    system.startSystem();
                } catch (e: Dynamic) {
                    trace('Error starting system ${system.systemName}: $e');
                }
            }
        }
    }

    public function unregisterSystem(system: ISystem): Void {
        if (systems.remove(system)) {
            if (isRunning && system.enabled) {
                try {
                    system.stopSystem();
                } catch (e: Dynamic) {
                    trace('Error stopping system ${system.systemName}: $e');
                }
            }
        }
    }

    public function registerPlugin(plugin: IEcsRxPlugin): Void {
        if (!plugins.contains(plugin)) {
            plugins.push(plugin);
        }
    }

    public function unregisterPlugin(plugin: IEcsRxPlugin): Void {
        plugins.remove(plugin);
    }

    public function dispose(): Void {
        stopApplication();
        collectionManager.dispose();
        entityDatabase.dispose();
        serviceContainer.clear();
        _applicationStartedSubject.on_completed();
        _applicationStoppedSubject.on_completed();
    }

#if haxe_injection 
    public function createSystemWithDI<T: ISystem>(systemClass: Class<T>): T {
        // Находим DI плагин 
        for (plugin in plugins) {
            if (Std.isOfType(plugin, ecsrx.plugins.DIPlugin)) {
                var diPlugin: ecsrx.plugins.DIPlugin = cast plugin;
                var serviceProvider = diPlugin.getServiceProvider();
                if (serviceProvider != null) {
                    try {
                        return serviceProvider.getService(systemClass);
                    } catch (e: Dynamic) {
                        trace('Could not create system via DI: $e');
                    }
                }
                break;
            }
        }
        // Если DI не работает, создаем вручную 
        return createSystemManually(systemClass);
    }

    private function createSystemManually<T: ISystem>(systemClass: Class<T>): T {
        try {
            return Type.createInstance(systemClass, []);
        } catch (e: Dynamic) {
            trace('Could not create system manually: $e');
            return null;
        }
    }
#end 

#if haxe_injection 
    public function getServiceProvider(): ServiceProvider {
        // Находим DI плагин и возвращаем его провайдер 
        for (plugin in plugins) {
            if (Std.isOfType(plugin, ecsrx.plugins.DIPlugin)) {
                var diPlugin: ecsrx.plugins.DIPlugin = cast plugin;
                return diPlugin.getServiceProvider();
            }
        }
        return null;
    }
#end
}