package examples.systems;

import ecsrx.systems.AbstractReactToEntitySystem;
import ecsrx.entities.Entity;
import examples.PositionComponent;
import examples.EnemyComponent;
import rx.Observable;

class EnemyAISystem extends AbstractReactToEntitySystem {
	private var _playerEntity:Entity;
	private var _entityDatabase:ecsrx.entities.IEntityDatabase;

	public function new(playerEntity:Entity, entityDatabase:ecsrx.entities.IEntityDatabase) {
		super("EnemyAISystem", 200);
		this._playerEntity = playerEntity;
		this._entityDatabase = entityDatabase;
	}

	override public function reactToEntity():Observable<Entity> {
		// Реагируем на добавление врагов
		return _entityDatabase.entityAdded().filter(entity -> entity.hasComponent(EnemyComponent));
	}

	override public function process(entity:Entity):Void {
		if (_playerEntity == null || !entity.hasComponent(PositionComponent) || !entity.hasComponent(EnemyComponent)) {
			return;
		}
		var enemyPosition = entity.getComponent(PositionComponent);
		var enemyComponent = entity.getComponent(EnemyComponent);
		var playerPosition = _playerEntity.getComponent(PositionComponent);
		// Простой AI: двигаемся к игроку
		var dx = playerPosition.x - enemyPosition.x;
		var dy = playerPosition.y - enemyPosition.y;
		var distance = Math.sqrt(dx * dx + dy * dy);
		if (distance > 0) {
			var moveX = (dx / distance) * enemyComponent.speed;
			var moveY = (dy / distance) * enemyComponent.speed;
			enemyPosition.x += moveX;
			enemyPosition.y += moveY;
		}
	}
}