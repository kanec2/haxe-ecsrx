import ecsrx.framework.EcsRxApplication;
import ecsrx.entities.Entity;
import ecsrx.systems.examples.*;
import ecsrx.plugins.CorePlugin;

import ecsrx.types.Components;

class TestMain {
	public static function main() {
		trace("Starting EcsRx game test...");
		var app = new EcsRxApplication();
		// Регистрируем плагин
		app.registerPlugin(new CorePlugin()); // Создаем коллекцию для тестирования
		var playerCollection = app.collectionManager.createCollection(function(entity) {
			return entity.hasComponent(PlayerComponent);
		}, "players"); // Регистрируем игровые системы
		var setupSystem = new ExampleSetupSystem(app.entityDatabase);
		var healthSystem = new HealthSystem(app.entityDatabase);
		var playerInputSystem = new PlayerInputSystem(app.entityDatabase);
		var movementSystem = new MovementSystem(app.entityDatabase);
		var collisionSystem = new CollisionSystem(app.entityDatabase);
		var reactToGroupSystem = new ExampleReactToGroupSystem(playerCollection);
		app.registerSystem(setupSystem); 
		app.registerSystem(healthSystem);
		app.registerSystem(playerInputSystem);
		app.registerSystem(movementSystem);
		app.registerSystem(collisionSystem);
		app.registerSystem(reactToGroupSystem); // Запускаем приложение
		app.startApplication(); // Создаем игрока вручную для теста
		createTestPlayer(app.entityDatabase); // Создаем врага для теста
		createTestEnemy(app.entityDatabase); // Имитируем несколько обновлений
		trace("Simulating 5 seconds of gameplay...");
		for (i in 0...300) { // 300 кадров ~ 5 секунд при 60 FPS // Вызываем update для Manual систем
			for (system in app.systems) {
				if (system.enabled && Std.isOfType(system, ecsrx.systems.IManualSystem)) {
					var manualSystem:ecsrx.systems.IManualSystem = cast system;
					manualSystem.update(1 / 60); // Примерный deltaTime
				}
			} // Периодически выводим состояние игрока
			if (i % 60 == 0) {
				var players = app.entityDatabase.getEntities().filter(function(e) {
					return e.hasComponent(PlayerComponent);
				});
				if (players.length > 0) {
					var player = players[0];
					var pos = player.getComponent(PositionComponent);
					var health = player.getComponent(HealthComponent);
					trace('Player at (${pos.x}, ${pos.y}), Health: ${health.currentHealth}/${health.maxHealth}');
				}
			}
		}
		app.dispose();
		trace("Game test completed successfully!");
	}

	private static function createTestPlayer(entityDatabase:ecsrx.entities.IEntityDatabase):Void {
		var player = entityDatabase.createEntity("Player");
		player.addComponent(new PositionComponent(100, 100));
		player.addComponent(new HealthComponent(100));
		player.addComponent(new PlayerComponent());
		player.addComponent(new SpriteComponent("player.png"));
		player.addComponent(new MovementComponent(200));
		trace("Created test player");
	}

	private static function createTestEnemy(entityDatabase:ecsrx.entities.IEntityDatabase):Void {
		var enemy = entityDatabase.createEntity("Enemy");
		enemy.addComponent(new PositionComponent(150, 150));
		enemy.addComponent(new EnemyComponent(5, 0.5));
		enemy.addComponent(new SpriteComponent("enemy.png"));
		enemy.addComponent(new HealthComponent(50));
		trace("Created test enemy");
	}
}