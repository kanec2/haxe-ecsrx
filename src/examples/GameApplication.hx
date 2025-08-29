package examples;

import ecsrx.framework.EcsRxApplication;
import ecsrx.framework.FrameworkBuilder;
import ecsrx.entities.Entity;
import examples.systems.*;

class GameApplication {
	private var _application:ecsrx.framework.IEcsRxApplication;
	private var _playerEntity:Entity;

	public function new() {
		createApplication();
		setupGame();
	}

	private function createApplication():Void {
		_application = new FrameworkBuilder().build();
	}

	private function setupGame():Void {
		// Создаем игрока
		_playerEntity = _application.entityDatabase.createEntity("Player");
		_playerEntity.addComponent(new PositionComponent(400, 300));
		_playerEntity.addComponent(new HealthComponent(100));
		_playerEntity.addComponent(new PlayerComponent());
		_playerEntity.addComponent(new SpriteComponent("player.png"));
		// Регистрируем системы
		registerSystems();
		// Запускаем приложение
		_application.startApplication();
	}

	private function registerSystems():Void {
		// Системы ввода и управления
		_application.registerSystem(new PlayerInputSystem(_playerEntity));
		// Системы AI
		_application.registerSystem(new EnemyAISystem(_playerEntity, _application.entityDatabase));
		// Системы здоровья
		_application.registerSystem(new HealthSystem(_application.entityDatabase));
		// Системы коллизий
		_application.registerSystem(new CollisionSystem(_application.entityDatabase));
		// Системы уровней
		_application.registerSystem(new LevelSystem(_application.entityDatabase));
		// Системы очков
		_application.registerSystem(new ScoreSystem(_application.entityDatabase));
	}

	public function update(elapsedTime:Float):Void {
		// Обновляем manual системы
		for (system in _application.systems) {
			if (system.enabled && Std.isOfType(system, ecsrx.systems.IManualSystem)) {
				var manualSystem:ecsrx.systems.IManualSystem = cast system;
				manualSystem.update(elapsedTime);
			}
		}
	}

	public function dispose():Void {
		_application.dispose();
	}

	public function getPlayer():Entity {
		return _playerEntity;
	}
}