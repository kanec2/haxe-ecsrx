package examples.systems;

import ecsrx.systems.AbstractReactToEntitySystem;
import ecsrx.entities.Entity;
import examples.PlayerComponent;
import rx.Observable;

class ScoreSystem extends AbstractReactToEntitySystem {
	private var _entityDatabase:ecsrx.entities.IEntityDatabase;
	private var _score:Int = 0;
	private var _kills:Int = 0;

	public function new(entityDatabase:ecsrx.entities.IEntityDatabase) {
		super("ScoreSystem", 400);
		this._entityDatabase = entityDatabase;
	}

	override public function reactToEntity():Observable<Entity> {
		// Реагируем на удаление сущностей (возможно убийства)
		return _entityDatabase.entityRemoved().filter(entity -> entity.hasComponent(examples.EnemyComponent));
	}

	override public function process(entity:Entity):Void {
		// Увеличиваем счет при убийстве врага
		_score += 100;
		_kills++;
		trace('Enemy killed! Score: $_score, Kills: $_kills');
		// Обновляем счет игрока
		updatePlayerScore();
	}

	private function updatePlayerScore():Void {
		var players = _entityDatabase.getEntities().filter(entity -> entity.hasComponent(PlayerComponent));
		if (players.length > 0) {
			var player = players[0];
			// Здесь можно обновить UI или другие компоненты игрока
		}
	}

	public function getScore():Int {
		return _score;
	}

	public function getKills():Int {
		return _kills;
	}
}