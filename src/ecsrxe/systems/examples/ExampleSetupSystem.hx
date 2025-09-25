package ecsrx.systems.examples;

import ecsrx.systems.AbstractSetupSystem;
import ecsrx.entities.IEntityDatabase;

class ExampleSetupSystem extends AbstractSetupSystem {
	private var _entityDatabase:IEntityDatabase;

	public function new(entityDatabase:IEntityDatabase) {
		super("ExampleSetupSystem", 0);
		this._entityDatabase = entityDatabase;
	}

	public override function setup():Void {
		// Создаем начальные сущности
		var player = _entityDatabase.createEntity("Player");
		// player.addComponent(new PositionComponent(0, 0));
		// player.addComponent(new HealthComponent(100));
		trace("Player entity created");
	}
}