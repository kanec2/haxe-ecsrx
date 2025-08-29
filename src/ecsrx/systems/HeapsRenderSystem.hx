package ecsrx.systems;

import ecsrx.entities.Entity;
import ecsrx.systems.AbstractReactToEntitySystem;
import h2d.Scene;
import h2d.Sprite;
import rx.Observable;

class HeapsRenderSystem extends AbstractReactToEntitySystem {
	private var _scene:h2d.Scene;
	private var _spriteCache:Map<Int, h2d.Sprite> = new Map();

	public function new(scene:h2d.Scene) {
		super("HeapsRenderSystem", 1000);
		this._scene = scene;
	}

	override public function reactToEntity():Observable<Entity> {
		// Реагируем на добавление сущностей с компонентом Position и Sprite
		return null; // Будет реализовано с EntityDatabase
	}

	override public function process(entity:Entity):Void {
		// Рендерим сущность
		renderEntity(entity);
	}

	private function renderEntity(entity:Entity):Void {
		// Пример рендеринга
		/* 
			if (entity.hasComponent(PositionComponent) && entity.hasComponent(SpriteComponent)) { 
			var position = entity.getComponent(PositionComponent); 
			var spriteData = entity.getComponent(SpriteComponent); 
			var sprite = getOrCreateSprite(entity.id, spriteData.texture); sprite.x = position.x; sprite.y = position.y; } 
		 */}

	private function getOrCreateSprite(id:Int, texture:String):h2d.Sprite {
		if (!_spriteCache.exists(id)) {
			var sprite = new h2d.Sprite(_scene);
			// sprite.tile = h2d.Tile.fromTexture(texture);
			_spriteCache.set(id, sprite);
		}
		return _spriteCache.get(id);
	}

	override public function stopSystem():Void {
		// Очищаем спрайты
		for (sprite in _spriteCache) {
			sprite.remove();
		}
		_spriteCache.clear();
		super.stopSystem();
	}
}