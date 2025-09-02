package ecsrx.systems;

import ecsrx.systems.AbstractManualSystem;
import ecsrx.plugins.HaxeUIPlugin;
import ecsrx.entities.Entity;
import ecsrx.types.PlayerComponent;
import ecsrx.types.HealthComponent;
import haxe.ui.components.Label;
//import haxe.ui.components.ProgressBar;
import haxe.ui.containers.HBox;
import haxe.ui.containers.VBox;
import haxe.ui.core.Component;
class HaxeUISystem extends AbstractManualSystem {
	private var _entityDatabase:ecsrx.entities.IEntityDatabase;
	private var _haxeUIPlugin:HaxeUIPlugin;
	private var _healthLabel:Label;
	private var _healthBarComponent:Component;
	private var _scoreLabel:Label;
	private var _fpsLabel:Label;
	private var _lastPlayerHealth:Int = -1;
    private var _lastPlayerMaxHealth:Int = -1;
	private var _lastPlayerScore:Int = -1;

	public function new(entityDatabase:ecsrx.entities.IEntityDatabase, haxeUIPlugin:HaxeUIPlugin) {
		super("HaxeUISystem", 1200);
		// Очень высокий приоритет для UI
		this._entityDatabase = entityDatabase;
		this._haxeUIPlugin = haxeUIPlugin;
		createUI();
	}

	private function createUI():Void {
		var root = _haxeUIPlugin.getRootComponent();
		if (root == null)
			return;
		// Создаем вертикальный контейнер для UI
		var uiContainer = new VBox();
		uiContainer.width = 300;
		uiContainer.height = 200;
		uiContainer.style.backgroundColor = 0x000000;
		uiContainer.style.opacity = 0.7;
		uiContainer.left = 10;
		uiContainer.top = 10;
		// Заголовок
		var titleLabel = new Label();
		titleLabel.text = "Game Stats";
		titleLabel.style.fontSize = 16;
		titleLabel.style.color = 0xFFFFFF;
		uiContainer.addComponent(titleLabel);
		// Health label
		_healthLabel = new Label();
		_healthLabel.text = "Health: 100/100";
		_healthLabel.style.color = 0xFFFFFF;
		uiContainer.addComponent(_healthLabel);
		// Health bar
		_healthBarComponent = new Component();
		_healthBarComponent.width = 200;
		_healthBarComponent.height = 20;
		_healthBarComponent.style.backgroundColor = 0x00FF00;
		uiContainer.addComponent(_healthBarComponent);
		// Score label
		_scoreLabel = new Label();
		_scoreLabel.text = "Score: 0";
		_scoreLabel.style.color = 0xFFFFFF;
		uiContainer.addComponent(_scoreLabel);
		// FPS label
		_fpsLabel = new Label();
		_fpsLabel.text = "FPS: 60";
		_fpsLabel.style.color = 0xFFFFFF;
		uiContainer.addComponent(_fpsLabel);
		root.addComponent(uiContainer);
	}

	override public function update(elapsedTime:Float):Void {
		updatePlayerStats();
		updateFPS();
	}

	private function updatePlayerStats():Void {
		var players = _entityDatabase.getEntities().filter(function(entity) {
			return entity.hasComponent(PlayerComponent);
		});
		if (players.length > 0) {
			var player = players[0];
			if (player.hasComponent(HealthComponent)) {
				var health = player.getComponent(HealthComponent);
				// Обновляем только если значения изменились
				if (health.currentHealth != _lastPlayerHealth || health.maxHealth != _lastPlayerMaxHealth) {
					if (_healthBarComponent != null) {
						var healthPercent = health.maxHealth > 0 ? health.currentHealth / health.maxHealth : 0;
						_healthBarComponent.width = 200 * healthPercent;
						_healthLabel.text = 'Health: ${health.currentHealth}/${health.maxHealth}';

						// Меняем цвет полоски в зависимости от здоровья
						if (health.currentHealth <= 0) {
							_healthBarComponent.style.backgroundColor = 0x808080; // Серый
						} else if (health.currentHealth < health.maxHealth * 0.3) {
							_healthBarComponent.style.backgroundColor = 0xFF0000; // Красный
						} else if (health.currentHealth < health.maxHealth * 0.6) {
							_healthBarComponent.style.backgroundColor = 0xFFFF00; // Желтый
						} else {
							_healthBarComponent.style.backgroundColor = 0x00FF00; // Зеленый
						}
					}
					// Обновляем счет (если есть компонент счета)
					if (player.hasComponent(PlayerComponent)) {
						var playerComp = player.getComponent(PlayerComponent);
						if (playerComp.score != _lastPlayerScore) {
							_scoreLabel.text = 'Score: ${playerComp.score}';
							_lastPlayerScore = playerComp.score;
						}
					}
				}
				_lastPlayerHealth = health.currentHealth;
				_lastPlayerMaxHealth = health.maxHealth;
			}
		} else {
			// Нет игрока
			if (_lastPlayerHealth != -2) {
				_healthLabel.text = "Health: No Player";

				if (_healthBarComponent != null) { _healthBarComponent.width = 0; _healthBarComponent.style.backgroundColor = 0x808080; } _lastPlayerHealth = -2;
			}
		}
	}

	private function updateFPS():Void {
		// Простой способ отслеживания FPS
		static var frameCount = 0;
		static var lastTime = 0.0;
		static var fps = 60.0;
		frameCount++;
		var currentTime = haxe.Timer.stamp();
		if (currentTime - lastTime >= 1.0) {
			fps = frameCount / (currentTime - lastTime);
			frameCount = 0;
			lastTime = currentTime;
			_fpsLabel.text = 'FPS: ${Math.round(fps)}';
		}
	}

	override public function stopSystem():Void {
		super.stopSystem();
		// Очистка UI компонентов может быть в плагине
	}
}