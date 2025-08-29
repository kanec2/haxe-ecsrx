package examples.systems;

import ecsrx.systems.AbstractSetupSystem;
import ecsrx.entities.Entity;
import examples.PositionComponent;
import examples.EnemyComponent;
import examples.SpriteComponent;

class LevelSystem extends AbstractSetupSystem {
	private var _entityDatabase:ecsrx.entities.IEntityDatabase;
	private var _currentLevel:Int = 1;
	private var _enemiesPerLevel:Int = 3;

	public function new(entityDatabase:ecsrx.entities.IEntityDatabase) {
		super("LevelSystem", 50);
		this._entityDatabase = entityDatabase;
	}

	override public function setup():Void {
		spawnEnemiesForLevel();
	}

	private function spawnEnemiesForLevel():Void {
		var enemiesToSpawn = _enemiesPerLevel * _currentLevel;
		for (i in 0...enemiesToSpawn) {
			var enemy = _entityDatabase.createEntity("Enemy_" + i);
			enemy.addComponent(new PositionComponent(Math.random() * 800, Math.random() * 600));
			enemy.addComponent(new EnemyComponent(5 + _currentLevel, 0.5 + _currentLevel * 0.1));
			enemy.addComponent(new SpriteComponent("enemy.png"));
			enemy.addComponent(new examples.HealthComponent(50 + _currentLevel * 10));
		}
		trace('Spawned $enemiesToSpawn enemies for level $_currentLevel');
	}

	public function nextLevel():Void {
		_currentLevel++;
		spawnEnemiesForLevel();
		trace('Advanced to level $_currentLevel');
	}
}