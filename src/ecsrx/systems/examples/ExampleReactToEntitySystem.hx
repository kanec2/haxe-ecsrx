package ecsrx.systems.examples;

import ecsrx.systems.AbstractReactToEntitySystem;
import ecsrx.entities.Entity;
import rx.Observable;

class ExampleReactToEntitySystem extends AbstractReactToEntitySystem {
	private var _entityDatabase:ecsrx.entities.IEntityDatabase;

	public function new(entityDatabase:ecsrx.entities.IEntityDatabase) {
		super("ExampleReactToEntitySystem", 100);
		this._entityDatabase = entityDatabase;
	}

	override public function reactToEntity():Observable<Entity> {
		// Реагируем на добавление сущностей
		return _entityDatabase.entityAdded();
	}

	override public function process(entity:Entity):Void {
		trace('Processing entity: ${entity.id} (${entity.name})');
	}
}