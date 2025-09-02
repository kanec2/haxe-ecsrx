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
		trace("HScript plugin initializing...");
		setupInterpreter(application);
	}

	private function setupInterpreter(application:IEcsRxApplication):Void {
		// Добавляем доступ к основным компонентам приложения
		_interp.variables.set("app", application);
		_interp.variables.set("entities", application.entityDatabase);
		_interp.variables.set("collections", application.collectionManager);
		// Добавляем типы для использования в скриптах
		_interp.variables.set("Entity", ecsrx.entities.Entity);
		_interp.variables.set("PositionComponent", ecsrx.types.PositionComponent);
		_interp.variables.set("HealthComponent", ecsrx.types.HealthComponent);
		_interp.variables.set("PlayerComponent", ecsrx.types.PlayerComponent);
		_interp.variables.set("EnemyComponent", ecsrx.types.EnemyComponent);
		_interp.variables.set("SpriteComponent", ecsrx.types.SpriteComponent);
		_interp.variables.set("MovementComponent", ecsrx.types.MovementComponent);
		trace("HScript interpreter configured");
	}

	public function afterApplicationStarts(application:IEcsRxApplication):Void {
		trace("HScript plugin initialized");
	}

	public function beforeApplicationStops(application:IEcsRxApplication):Void {
		// Очистка
		_interp.variables.clear();
	}

	public function afterApplicationStops(application:IEcsRxApplication):Void {
		trace("HScript plugin stopped");
		_parser = null;
		_interp = null;
	}

	public function getParser():Parser {
		return _parser;
	}

	public function getInterpreter():Interp {
		return _interp;
	}

	public function executeScript(script:String):Dynamic {
		try {
			var program = _parser.parseString(script);
			return _interp.execute(program);
		} catch (e:Dynamic) {
			trace("Script execution error: " + e);
			return null;
		}
	}

	public function executeScriptFile(filePath:String):Dynamic {
		try {
			var content = sys.io.File.getContent(filePath);
			return executeScript(content);
		} catch (e:Dynamic) {
			trace("Script file execution error: " + e);
			return null;
		}
	}
}