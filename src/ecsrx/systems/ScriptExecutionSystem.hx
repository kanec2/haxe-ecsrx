package ecsrx.systems;

import ecsrx.systems.AbstractReactToEntitySystem;
import ecsrx.entities.Entity;
import ecsrx.plugins.HScriptPlugin;
import ecsrx.types.ScriptComponent;
import rx.Observable;

class ScriptExecutionSystem extends AbstractReactToEntitySystem {
	private var _entityDatabase:ecsrx.entities.IEntityDatabase;
	private var _hscriptPlugin:HScriptPlugin;

	public function new(entityDatabase:ecsrx.entities.IEntityDatabase, hscriptPlugin:HScriptPlugin) {
		super("ScriptExecutionSystem", 60);
		this._entityDatabase = entityDatabase;
		this._hscriptPlugin = hscriptPlugin;
	}

	override public function reactToEntity():Observable<Entity> {
		// Реагируем на добавление сущностей со скриптами
		return _entityDatabase.entityAdded().filter(function(entity) {
			return entity.hasComponent(ScriptComponent);
		});
	}

	override public function process(entity:Entity):Void {
		var scriptComponent = entity.getComponent(ScriptComponent);
		if (!scriptComponent.enabled)
			return;
		// Выполняем инициализационный скрипт при добавлении сущности
		executeInitializationScript(entity);
	}

	private function executeInitializationScript(entity:Entity):Void {
		var scriptComponent = entity.getComponent(ScriptComponent);
		var interp = _hscriptPlugin.getInterpreter();
		// Устанавливаем контекст
		interp.variables.set("entity", entity);
		interp.variables.set("this", entity);
		try {
			var initScript = " if (typeof onStart != 'undefined') { onStart(); } ";
			// Или можно выполнить специальный инициализационный код
			if (scriptComponent.scriptCode != null && scriptComponent.scriptCode.indexOf("onStart") != -1) {
				_hscriptPlugin.executeScript(scriptComponent.scriptCode);
			}
		} catch (e:Dynamic) {
			trace('Script initialization error for entity ${entity.id}: $e');
		}
	}
}