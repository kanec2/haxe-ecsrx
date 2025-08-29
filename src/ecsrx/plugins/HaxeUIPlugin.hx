package ecsrx.plugins;

import ecsrx.framework.IEcsRxApplication;

// import haxe.ui.Toolkit; // когда будет доступна библиотека
class HaxeUIPlugin implements IEcsRxPlugin {
	public var pluginName:String = "HaxeUIPlugin";

	public function new() {}

	public function beforeApplicationStarts(application:IEcsRxApplication):Void {
		// Инициализация HaxeUI
		// Toolkit.init();
	}

	public function afterApplicationStarts(application:IEcsRxApplication):Void {
		// Дополнительная настройка UI
	}

	public function beforeApplicationStops(application:IEcsRxApplication):Void {
		// Очистка UI
	}

	public function afterApplicationStops(application:IEcsRxApplication):Void {
		// Финальная очистка
	}
}