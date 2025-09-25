package ecsrx.plugins;

import ecsrx.framework.IEcsRxApplication;

class CorePlugin implements IEcsRxPlugin {
	public var pluginName:String = "CorePlugin";

	public function new() {}

	public function beforeApplicationStarts(application:IEcsRxApplication):Void {
		// Регистрируем базовые системы
		registerCoreSystems(application);
	}

	private function registerCoreSystems(application:IEcsRxApplication):Void {
		// Здесь можно зарегистрировать базовые системы фреймворка
	}

	public function afterApplicationStarts(application:IEcsRxApplication):Void {
		trace("Core systems initialized");
	}

	public function beforeApplicationStops(application:IEcsRxApplication):Void {
		// Очистка перед остановкой
	}

	public function afterApplicationStops(application:IEcsRxApplication):Void { 
        // Финальная очистка
	}
}