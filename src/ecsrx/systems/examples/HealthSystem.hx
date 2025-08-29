package ecsrx.systems.examples;

import ecsrx.entities.Entity;
import ecsrx.systems.AbstractReactToEntitySystem;
import rx.Observable;

class HealthSystem extends AbstractReactToEntitySystem {
	private var _entityDatabase:ecsrx.entities.IEntityDatabase;

	public function new(entityDatabase:ecsrx.entities.IEntityDatabase) {
		super("HealthSystem", 100);
		this._entityDatabase = entityDatabase;
	}

	override public function reactToEntity():Observable<Entity> {
		return _entityDatabase.entityAdded().filter(entity -> entity.hasComponent(HealthComponent));
	}

	override public function process(entity:Entity):Void {
		var health = entity.getComponent(HealthComponent);
		if (health.value <= 0) {
			trace('Entity ${entity.id} has died!');
			_entityDatabase.destroyEntity(entity);
		}
	}
}

// Пример компонента
class HealthComponent {
	public var value:Int;

	public function new(value:Int = 100) {
		this.value = value;
	}
}