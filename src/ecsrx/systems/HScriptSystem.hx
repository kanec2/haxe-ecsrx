package ecsrx.systems;

import ecsrx.systems.AbstractManualSystem;
import ecsrx.entities.Entity;
import ecsrx.plugins.HScriptPlugin;
import ecsrx.types.ScriptComponent;

class HScriptSystem extends AbstractManualSystem {
	private var _entityDatabase:ecsrx.entities.IEntityDatabase;
	private var _hscriptPlugin:HScriptPlugin;

	public function new(entityDatabase:ecsrx.entities.IEntityDatabase, hscriptPlugin:HScriptPlugin) {
		super("HScriptSystem", 50);
		this._entityDatabase = entityDatabase;
		this._hscriptPlugin = hscriptPlugin;
	}

	override public function update(elapsedTime:Float):Void {
		var entities = _entityDatabase.getEntities();
		for (entity in entities) {
			if (entity.hasComponent(ScriptComponent)) {
				executeEntityScript(entity, elapsedTime);
			}
		}
	}

	private function executeEntityScript(entity:Entity, elapsedTime:Float):Void {
		var scriptComponent = entity.getComponent(ScriptComponent);
		// Обновляем переменные интерпретатора для текущей сущности
		var interp = _hscriptPlugin.getInterpreter();
		interp.variables.set("entity", entity);
		interp.variables.set("elapsedTime", elapsedTime);
		interp.variables.set("this", entity);
		// для удобства
		try {
			if (scriptComponent.scriptPath != null && scriptComponent.scriptPath != "") {
				// Выполняем скрипт из файла
				_hscriptPlugin.executeScriptFile(scriptComponent.scriptPath);
			} else if (scriptComponent.scriptCode != null && scriptComponent.scriptCode != "") {
				// Выполняем встроенный скрипт
				_hscriptPlugin.executeScript(scriptComponent.scriptCode);
			}
		} catch (e:Dynamic) {
			trace('Script execution error for entity ${entity.id}: $e');
		}
	}
}