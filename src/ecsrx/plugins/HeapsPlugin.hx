package ecsrx.plugins;

import ecsrx.framework.IEcsRxApplication;
import h2d.Scene;

class HeapsPlugin implements IEcsRxPlugin {
	public var pluginName:String = "HeapsPlugin";

	private var _scene:h2d.Scene;

	public function new(scene:h2d.Scene) {
		this._scene = scene;
	}

	public function beforeApplicationStarts(application:IEcsRxApplication):Void {
		// Регистрируем Scene в DI контейнере
		application.dependencyContainer.bind().to(_scene).asSingleton();
	}

	public function afterApplicationStarts(application:IEcsRxApplication):Void {
		// Дополнительная инициализация после запуска
	}

	public function beforeApplicationStops(application:IEcsRxApplication):Void {
		// Очистка перед остановкой
	}

	public function afterApplicationStops(application:IEcsRxApplication):Void { // Финальная очистка
	}
}