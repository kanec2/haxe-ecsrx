package ecsrx.plugins;

import ecsrx.framework.IEcsRxApplication;
import hscript.Interp;
import hscript.Parser;

class HScriptPlugin implements IEcsRxPlugin {
	public var pluginName:String = "HScriptPlugin";

	private var _parser:Parser;
	private var _interp:Interp;

	public function new() {
		this._parser = new Parser();
		this._interp = new Interp();
	}

	public function beforeApplicationStarts(application:IEcsRxApplication):Void {
		// Регистрируем скриптовые компоненты в DI
		application.dependencyContainer.bind().to(_parser).asSingleton();
		application.dependencyContainer.bind().to(_interp).asSingleton();
	}

	public function afterApplicationStarts(application:IEcsRxApplication):Void {
		// Настройка интерпретатора
		setupInterpreter(application);
	}

	private function setupInterpreter(application:IEcsRxApplication):Void {
		// Добавляем доступ к основным компонентам приложения
		_interp.variables.set("app", application);
		_interp.variables.set("entities", application.entityDatabase);
	}

	public function beforeApplicationStops(application:IEcsRxApplication):Void {
		// Очистка
	}

	public function afterApplicationStops(application:IEcsRxApplication):Void { 
        // Финальная очистка
	}
}