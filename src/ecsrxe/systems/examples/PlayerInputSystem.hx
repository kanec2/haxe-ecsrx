package ecsrx.systems.examples;

import ecsrx.systems.AbstractManualSystem;
import ecsrx.entities.Entity;
import ecsrx.systems.AbstractManualSystem;
import ecsrx.entities.Entity;
import ecsrx.types.PositionComponent;
import ecsrx.types.MovementComponent;
import ecsrx.types.PlayerComponent;

class PlayerInputSystem extends AbstractManualSystem {
	private var _entityDatabase:ecsrx.entities.IEntityDatabase;
	private var _moveSpeed:Float = 200.0;

	public function new(entityDatabase:ecsrx.entities.IEntityDatabase) {
		super("PlayerInputSystem", 100);
		this._entityDatabase = entityDatabase;
	}

	override public function update(elapsedTime:Float):Void {
		// Находим игрока
		var players = _entityDatabase.getEntities().filter(function(entity) {
			return entity.hasComponent(PlayerComponent);
		});
		if (players.length > 0) {
			var player = players[0];
			updatePlayerMovement(player, elapsedTime);
		}
	}

	private function updatePlayerMovement(player:Entity, elapsedTime:Float):Void {
		if (!player.hasComponent(PositionComponent) || !player.hasComponent(MovementComponent)) {
			return;
		}
		var position = player.getComponent(PositionComponent);
		var movement = player.getComponent(MovementComponent);
		// Сброс скорости
		movement.velocityX = 0;
		movement.velocityY = 0;
		// Простое управление (в реальной игре будет интеграция с Heaps input)
		/* 
			if (hxd.Key.isDown(hxd.Key.LEFT)) { movement.velocityX = -_moveSpeed; } 
			if (hxd.Key.isDown(hxd.Key.RIGHT)) { movement.velocityX = _moveSpeed; } 
			if (hxd.Key.isDown(hxd.Key.UP)) { movement.velocityY = -_moveSpeed; } 
			if (hxd.Key.isDown(hxd.Key.DOWN)) { movement.velocityY = _moveSpeed; } 
		 */
		// Пока симулируем движение для теста
		movement.velocityX = Math.sin(haxe.Timer.stamp()) * _moveSpeed;
		movement.velocityY = Math.cos(haxe.Timer.stamp()) * _moveSpeed;
		// Обновляем позицию
		position.x += movement.velocityX * elapsedTime;
		position.y += movement.velocityY * elapsedTime;
	}
}