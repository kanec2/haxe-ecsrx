package examples.systems;

import ecsrx.systems.AbstractManualSystem;
import ecsrx.entities.Entity;
import examples.PositionComponent;

class PlayerInputSystem extends AbstractManualSystem {
	private var _playerEntity:Entity;
	private var _moveSpeed:Float = 200.0;

	public function new(playerEntity:Entity) {
		super("PlayerInputSystem", 100);
		this._playerEntity = playerEntity;
	}

	override public function update(elapsedTime:Float):Void {
		if (_playerEntity == null || !_playerEntity.hasComponent(PositionComponent)) {
			return;
		}
		var position = _playerEntity.getComponent(PositionComponent);
		// Простое управление с клавиатуры (в реальной игре будет интеграция с Heaps)
		/* if (hxd.Key.isDown(hxd.Key.LEFT)) { position.x -= _moveSpeed * elapsedTime; } 
			if (hxd.Key.isDown(hxd.Key.RIGHT)) { position.x += _moveSpeed * elapsedTime; } 
			if (hxd.Key.isDown(hxd.Key.UP)) { position.y -= _moveSpeed * elapsedTime; } 
			if (hxd.Key.isDown(hxd.Key.DOWN)) { position.y += _moveSpeed * elapsedTime; 
			} 
		 */
		// Пока просто симулируем движение
		position.x += Math.sin(haxe.Timer.stamp()) * 10;
		position.y += Math.cos(haxe.Timer.stamp()) * 10;
	}
}