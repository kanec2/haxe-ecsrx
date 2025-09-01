package ecsrx.systems.examples;

import ecsrx.systems.AbstractReactToEntitySystem;
import ecsrx.entities.Entity;
import rx.Observable;
import ecsrx.types.Components;

class HealthSystem extends AbstractReactToEntitySystem {
	private var _entityDatabase:ecsrx.entities.IEntityDatabase;

	public function new(entityDatabase:ecsrx.entities.IEntityDatabase) {
		super("HealthSystem", 200);
		this._entityDatabase = entityDatabase;
	}

	override public function reactToEntity():Observable<Entity> {
		// Реагируем на обновления сущностей с компонентом здоровья
		return _entityDatabase.entityUpdated().filter(function(entity) {
			return entity.hasComponent(Components.HealthComponent);
		});
	}

	override public function process(entity:Entity):Void {
		var health = entity.getComponent(Components.HealthComponent);
		if (health.isDead()) {
			trace('Entity ${entity.id} has died!');
			_entityDatabase.destroyEntity(entity);
		}
	}
}