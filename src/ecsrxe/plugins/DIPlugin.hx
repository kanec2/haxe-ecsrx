package ecsrx.plugins;

import ecsrx.framework.IEcsRxApplication;

#if haxe_injection
import hx.injection.ServiceCollection;
import hx.injection.ServiceProvider;
#end
using hx.injection.ServiceExtensions;

class DIPlugin implements IEcsRxPlugin {
    public var pluginName:String = "DIPlugin";

#if haxe_injection
    private var _serviceCollection:ServiceCollection;
    private var _serviceProvider:ServiceProvider;
#end

    public function new() {}

    public function beforeApplicationStarts(application:IEcsRxApplication):Void {
        trace("DI plugin initializing...");
#if haxe_injection
        initializeDI(application);
#end
    }

#if haxe_injection
    private function initializeDI(application:IEcsRxApplication):Void {
        _serviceCollection = new ServiceCollection();
        // Регистрируем основные сервисы как инстансы 
        _serviceCollection.addService(ecsrx.entities.IEntityDatabase, application.entityDatabase);
        _serviceCollection.addService(ecsrx.collections.ICollectionManager, application.collectionManager);
        _serviceCollection.addService(IEcsRxApplication, application);
        trace("haxe-injection ServiceCollection initialized with services");
    }
#end

    public function afterApplicationStarts(application:IEcsRxApplication):Void {
        trace("DI plugin initialized");
#if haxe_injection
        // Создаем ServiceProvider после регистрации всех сервисов 
        if (_serviceCollection != null) {
            _serviceProvider = _serviceCollection.createProvider();
            trace("ServiceProvider created");
        }
#end
    }

    public function beforeApplicationStops(application:IEcsRxApplication):Void {
        // Очистка 
#if haxe_injection
        if (_serviceProvider != null) {
            _serviceProvider.destroy();
            // Очищаем деструктируемые сервисы 
        }
#end
    }

    public function afterApplicationStops(application:IEcsRxApplication):Void {
        trace("DI plugin stopped");
    }

#if haxe_injection
    public function getServiceProvider():ServiceProvider {
        return _serviceProvider;
    }

    public function getServiceCollection():ServiceCollection {
        return _serviceCollection;
    }

    public function getService<T>(type:Class<T>):T {
        if (_serviceProvider != null) {
            return _serviceProvider.getService(type);
        }
        return null;
    }

    public function hasService<T>(type:Class<T>):Bool {
        if (_serviceCollection != null) {
            return _serviceCollection.has(type);
        }
        return false;
    }

    // Утилиты для регистрации разных типов сервисов 
    public function addSingleton<T>(type:Class<T>, ?implementation:Class<T>):Void {
        if (_serviceCollection != null) {
            if (implementation != null) {
                _serviceCollection.addSingleton(type, implementation);
            } else {
                _serviceCollection.addSingleton(type);
            }
        }
    }

    public function addTransient<T>(type:Class<T>, ?implementation:Class<T>):Void {
        if (_serviceCollection != null) {
            if (implementation != null) {
                _serviceCollection.addTransient(type, implementation);
            } else {
                _serviceCollection.addTransient(type);
            }
        }
    }

    public function addScoped<T>(type:Class<T>, ?implementation:Class<T>):Void {
        if (_serviceCollection != null) {
            if (implementation != null) {
                _serviceCollection.addScoped(type, implementation);
            } else {
                _serviceCollection.addScoped(type);
            }
        }
    }

    public function addInstance<T>(type:Class<T>, instance:T):Void {
        if (_serviceCollection != null) {
            _serviceCollection.addService(type, instance);
        }
    }
#end
}