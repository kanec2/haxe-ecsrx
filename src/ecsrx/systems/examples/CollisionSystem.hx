package ecsrx.systems.examples;

import ecsrx.systems.AbstractManualSystem;
import ecsrx.entities.Entity;
import ecsrx.types.Components;

class CollisionSystem extends AbstractManualSystem {
	private var _entityDatabase:ecsrx.entities.IEntityDatabase;
	private var _collisionDistance:Float = 32.0;

	public function new(entityDatabase:ecsrx.entities.IEntityDatabase) {
		super("CollisionSystem", 250);
		this._entityDatabase = entityDatabase;
	}

	override public function update(elapsedTime:Float):Void {
		var entities = _entityDatabase.getEntities();
		var players = [];
		var enemies = [];
		// Разделяем сущности
		for (entity in entities) {
			if (entity.hasComponent(Components.PlayerComponent) && entity.hasComponent(Components.PositionComponent)) {
				players.push(entity);
			} else if (entity.hasComponent(Components.EnemyComponent) && entity.hasComponent(Components.PositionComponent)) {
				enemies.push(entity);
			}
		}
		// Проверяем коллизии
		for (player in players) {
			var playerPos = player.getComponent(Components.PositionComponent);
			for (enemy in enemies) {
				var enemyPos = enemy.getComponent(Components.PositionComponent);
				var distance = Math.sqrt(Math.pow(playerPos.x - enemyPos.x, 2) + Math.pow(playerPos.y - enemyPos.y, 2));
				if (distance < _collisionDistance) {
					handleCollision(player, enemy);
				}
			}
		}
	}

	private function handleCollision(player:Entity, enemy:Entity):Void {
		// Игрок получает урон от врага
		if (player.hasComponent(Components.HealthComponent) && enemy.hasComponent(Components.EnemyComponent)) {
			var playerHealth = player.getComponent(Components.HealthComponent);
			var enemyComponent = enemy.getComponent(Components.EnemyComponent);
			playerHealth.takeDamage(enemyComponent.damage);
			trace('Player hit! Health: ${playerHealth.currentHealth}/${playerHealth.maxHealth}');
		}
	}
}