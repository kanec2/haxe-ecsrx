package ecsrx.di;
class ServiceContainer {
  private
  var _services: Map < String,
  Dynamic > =new Map();
  private
  var _singletons: Map < String,
  Dynamic > =new Map();
  private
  var _factories: Map < String,
  Void -> Dynamic > =new Map();
  public
  function new() {}
  public
  function register < T > (type: Class < T > , instance: T) : ServiceContainer {
    var key = Type.getClassName(type);
    _services.set(key, instance);
    return this;
  }
  public
  function registerSingleton < T > (type: Class < T > , instance: T) : ServiceContainer {
    var key = Type.getClassName(type);
    _singletons.set(key, instance);
    return this;
  }
  public
  function registerFactory < T > (type: Class < T > , factory: Void ->T) : ServiceContainer {
    var key = Type.getClassName(type);
    _factories.set(key, factory);
    return this;
  }
  public
  function resolve < T > (type: Class < T > ) : T {
    var key = Type.getClassName(type);
    // Проверяем синглтоны
    if (_singletons.exists(key)) {
      return _singletons.get(key);
    }
    // Проверяем зарегистрированные сервисы 
    if (_services.exists(key)) {
      return _services.get(key);
    }
    // Проверяем фабрики 
    if (_factories.exists(key)) {
      var factory: Void ->T = _factories.get(key);
      var instance = factory();
      return instance;
    }
    // Пытаемся создать экземпляр напрямую 
    try {
      return Type.createInstance(type, []);
    } catch(e: Dynamic) {
      return null;
    }
  }
  public
  function hasService < T > (type: Class < T > ) : Bool {
    var key = Type.getClassName(type);
    return _services.exists(key) || _singletons.exists(key) || _factories.exists(key);
  }
  public
  function clear() : Void {
    _services.clear();
    _singletons.clear();
    _factories.clear();
  }
}