package examples.systems;

import ecsrx.systems.AbstractReactToEntitySystem;
import ecsrx.entities.Entity;
import examples.HealthComponent;
import rx.Observable;

class HealthSystem extends AbstractReactToEntitySystem {
	private var _entityDatabase:ecsrx.entities.IEntityDatabase;

	public function new(entityDatabase:ecsrx.entities.IEntityDatabase) {
		super("HealthSystem", 300);
		this._entityDatabase = entityDatabase;
	}

	override public function reactToEntity():Observable<Entity> {
		// Реагируем на обновление сущностей с компонентом здоровья
		return _entityDatabase.entityUpdated().filter(entity -> entity.hasComponent(HealthComponent));
	}

	override public function process(entity:Entity):Void {
		var health = entity.getComponent(HealthComponent);
		if (health.isDead()) {
			trace('Entity ${entity.id} has died!');
			_entityDatabase.destroyEntity(entity);
		}
	}
}