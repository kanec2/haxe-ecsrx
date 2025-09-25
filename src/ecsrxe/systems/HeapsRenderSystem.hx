package ecsrx.systems;

import ecsrx.systems.AbstractManualSystem;
import ecsrx.entities.Entity;
import ecsrx.types.PositionComponent;
import ecsrx.types.SpriteComponent;
import ecsrx.plugins.HeapsPlugin;
import h2d.Sprite;

class HeapsRenderSystem extends AbstractManualSystem {
	private var _entityDatabase:ecsrx.entities.IEntityDatabase;
	private var _heapsPlugin:HeapsPlugin;

	public function new(entityDatabase:ecsrx.entities.IEntityDatabase, heapsPlugin:HeapsPlugin) {
		super("HeapsRenderSystem", 1000);
		// Высокий приоритет для рендеринга
		this._entityDatabase = entityDatabase;
		this._heapsPlugin = heapsPlugin;
	}

	override public function update(elapsedTime:Float):Void {
		var entities = _entityDatabase.getEntities();
		for (entity in entities) {
			if (entity.hasComponent(PositionComponent) && entity.hasComponent(SpriteComponent)) {
				renderEntity(entity);
			}
		}
	}

	private function renderEntity(entity:Entity):Void {
		var position = entity.getComponent(PositionComponent);
		var spriteData = entity.getComponent(SpriteComponent);
		_heapsPlugin.updateSpritePosition(entity.id, position.x, position.y, spriteData.texture, spriteData.width, spriteData.height);
	}

	override public function stopSystem():Void {
		super.stopSystem();
		// Очистка может быть в плагине
	}
}