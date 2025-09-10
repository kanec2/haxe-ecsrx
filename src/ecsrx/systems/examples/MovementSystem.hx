package ecsrx.systems.examples;

import ecsrx.systems.AbstractManualSystem;
import ecsrx.entities.Entity;
import ecsrx.types.*;

class MovementSystem extends AbstractManualSystem {
	private var _entityDatabase:ecsrx.entities.IEntityDatabase;

	public function new(entityDatabase:ecsrx.entities.IEntityDatabase) {
		super("MovementSystem", 150);
		this._entityDatabase = entityDatabase;
	}

	override public function update(elapsedTime:Float):Void {
		var entities = _entityDatabase.getEntities();
		for (entity in entities) {
			if (entity.hasComponent(PositionComponent) && entity.hasComponent(MovementComponent)) {
				updateEntityPosition(entity, elapsedTime);
			}
		}
	}

	private function updateEntityPosition(entity:Entity, elapsedTime:Float):Void {
		var position = entity.getComponent(PositionComponent);
		var movement = entity.getComponent(MovementComponent);
		// Ограничиваем скорость
		var speed = Math.sqrt(movement.velocityX * movement.velocityX + movement.velocityY * movement.velocityY);
		if (speed > movement.maxSpeed) {
			var ratio = movement.maxSpeed / speed;
			movement.velocityX *= ratio;
			movement.velocityY *= ratio;
		}
		// Обновляем позицию
		position.x += movement.velocityX * elapsedTime;
		position.y += movement.velocityY * elapsedTime;
		trace('Entity ${entity.id} moved to (${position.x}, ${position.y})');
	}
}