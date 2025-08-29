package systems;

import ecs.Entity;
import ecs.systems.System;
import h2d.Scene;
import h2d.Sprite;

class RenderSystem implements System {
	private var scene:h2d.Scene;
	private var spriteCache:Map<Int, h2d.Sprite> = new Map();

	public function new(scene:h2d.Scene) {
		this.scene = scene;
	}

	public function update(entities:Array<Entity>):Void {
		for (entity in entities) {
			if (entity.hasComponent("PositionComponent") && entity.hasComponent("SpriteComponent")) {
				var position = entity.getComponent("PositionComponent");
				var spriteData = entity.getComponent("SpriteComponent");
				var sprite = getOrCreateSprite(entity.id, spriteData.texture);
				sprite.x = position.x;
				sprite.y = position.y;
			}
		}
	}

	private function getOrCreateSprite(id:Int, texture:String):h2d.Sprite {
		if (!spriteCache.exists(id)) {
			var sprite = new h2d.Sprite(scene);
			// Загрузка текстуры (пример)
			// sprite.tile = h2d.Tile.fromTexture(texture);
			spriteCache.set(id, sprite);
		}
		return spriteCache.get(id);
	}

	public function dispose():Void {
		for (sprite in spriteCache) {
			sprite.remove();
		}
		spriteCache.clear();
	}
}