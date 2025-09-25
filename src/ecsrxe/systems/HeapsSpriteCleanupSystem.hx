package ecsrx.systems;

import ecsrx.systems.AbstractReactToEntitySystem;
import ecsrx.entities.Entity;
import ecsrx.plugins.HeapsPlugin;
import rx.Observable;

class HeapsSpriteCleanupSystem extends AbstractReactToEntitySystem {
	private var _entityDatabase:ecsrx.entities.IEntityDatabase;
	private var _heapsPlugin:HeapsPlugin;

	public function new(entityDatabase:ecsrx.entities.IEntityDatabase, heapsPlugin:HeapsPlugin) {
		super("HeapsSpriteCleanupSystem", 1100);
		// Очень высокий приоритет
		this._entityDatabase = entityDatabase;
		this._heapsPlugin = heapsPlugin;
	}

	override public function reactToEntity():Observable<Entity> {
		// Реагируем на удаление сущностей
		return _entityDatabase.entityRemoved();
	}

	override public function process(entity:Entity):Void {
		// Удаляем спрайт при удалении сущности
		_heapsPlugin.removeSprite(entity.id);
		trace('Removed sprite for entity ${entity.id}');
	}
}