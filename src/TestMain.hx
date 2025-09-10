import hxd.App;
import ecsrx.framework.EcsRxApplication;
import ecsrx.entities.Entity;
import ecsrx.systems.examples. * ;
import ecsrx.plugins.CorePlugin;
import ecsrx.plugins.HeapsPlugin;
import ecsrx.plugins.HScriptPlugin;
import ecsrx.plugins.DIPlugin;
import ecsrx.systems.HeapsRenderSystem;
import ecsrx.systems.HeapsSpriteCleanupSystem;
import ecsrx.systems.HScriptSystem;
import ecsrx.systems.ScriptExecutionSystem;
import ecsrx.types. * ;
class TestMain extends hxd.App {
  private
  var _ecsApp: EcsRxApplication;
  private
  var _heapsPlugin: HeapsPlugin;
  private
  var _hscriptPlugin: HScriptPlugin;
  private
  var _diPlugin: DIPlugin;
  override
  function init() {
    super.init();
    trace("Initializing EcsRx with Heaps, HScript and DI...");
    // Создаем EcsRx приложение 
    _ecsApp = new EcsRxApplication();
    // Создаем и регистрируем плагины 
    _heapsPlugin = new HeapsPlugin(s2d);
    _hscriptPlugin = new HScriptPlugin();
    _diPlugin = new DIPlugin();
    _ecsApp.registerPlugin(_heapsPlugin);
    _ecsApp.registerPlugin(_hscriptPlugin);
    _ecsApp.registerPlugin(_diPlugin);
    _ecsApp.registerPlugin(new CorePlugin());
    // Создаем коллекцию игроков 
    var playerCollection = _ecsApp.collectionManager.createCollection(function(entity) {
      return entity.hasComponent(PlayerComponent);
    },
    "players");
    // Регистрируем все системы 
    var setupSystem = new ExampleSetupSystem(_ecsApp.entityDatabase);
    var healthSystem = new HealthSystem(_ecsApp.entityDatabase);
    var playerInputSystem = new PlayerInputSystem(_ecsApp.entityDatabase);
    var movementSystem = new MovementSystem(_ecsApp.entityDatabase);
    var collisionSystem = new CollisionSystem(_ecsApp.entityDatabase);
    var reactToGroupSystem = new ExampleReactToGroupSystem(playerCollection);
    // Heaps системы 
    var renderSystem = new HeapsRenderSystem(_ecsApp.entityDatabase, _heapsPlugin);
    var spriteCleanupSystem = new HeapsSpriteCleanupSystem(_ecsApp.entityDatabase, _heapsPlugin);
    // HScript системы 
    var hscriptSystem = new HScriptSystem(_ecsApp.entityDatabase, _hscriptPlugin);
    var scriptExecutionSystem = new ScriptExecutionSystem(_ecsApp.entityDatabase, _hscriptPlugin);
    // DI система 
    var diExampleSystem = new DIExampleSystem(_ecsApp.serviceContainer);
    _ecsApp.registerSystem(setupSystem);
    _ecsApp.registerSystem(healthSystem);
    _ecsApp.registerSystem(playerInputSystem);
    _ecsApp.registerSystem(movementSystem);
    _ecsApp.registerSystem(collisionSystem);
    _ecsApp.registerSystem(reactToGroupSystem);
    _ecsApp.registerSystem(renderSystem);
    _ecsApp.registerSystem(spriteCleanupSystem);
    _ecsApp.registerSystem(hscriptSystem);
    _ecsApp.registerSystem(scriptExecutionSystem);
    _ecsApp.registerSystem(diExampleSystem);
    // Запускаем приложение 
    _ecsApp.startApplication();
    // Создаем тестовые сущности 
    createTestEntities();
  }

	private function createTestEntities():Void {
		// Создаем игрока
		var player = _ecsApp.entityDatabase.createEntity("Player");
		player.addComponent(new PositionComponent(400, 300));
		player.addComponent(new HealthComponent(100));
		player.addComponent(new PlayerComponent());
		player.addComponent(new SpriteComponent("player.png", 32, 32));
		player.addComponent(new MovementComponent(200));

		var playerScript = new ScriptComponent();
		playerScript.scriptCode = " 
		// Пример скрипта для игрока 
		if (typeof entity != 'undefined' && typeof elapsedTime != 'undefined') { 
			// Можно получить доступ к компонентам 
			var pos = entity.getComponent(PositionComponent); 
			if (pos != null) { 
				// Простая логика в скрипте 
				// pos.x += Math.sin(elapsedTime) * 10; 
			} 
		} ";
		player.addComponent(playerScript);

		trace("Created player entity");
		// Создаем несколько врагов
		for (i in 0...5) {
			var enemy = _ecsApp.entityDatabase.createEntity("Enemy_" + i);
			enemy.addComponent(new PositionComponent(100 + i * 100, 100));
			enemy.addComponent(new EnemyComponent(10, 0.5));
			enemy.addComponent(new SpriteComponent("enemy.png", 32, 32));
			enemy.addComponent(new HealthComponent(50));
			enemy.addComponent(new MovementComponent(100));

			var enemyScript = new ScriptComponent();
			enemyScript.scriptCode = "
			// Скрипт для врага 
			var pos = entity.getComponent(PositionComponent); 
			var mov = entity.getComponent(MovementComponent); 
			if (pos != null && mov != null) { 
				// Простое поведение 
				mov.velocityX = Math.sin(entity.id * 0.1) * 50; 
				mov.velocityY = Math.cos(entity.id * 0.1) * 50; 
				} ";
			enemy.addComponent(enemyScript);

			trace("Created enemy entity " + i);
		}
	}

	override function update(dt:Float) {
		super.update(dt);
		// Обновляем Manual системы EcsRx
		if (_ecsApp != null && _ecsApp.isRunning) {
			for (system in _ecsApp.systems) {
				if (system.enabled && Std.isOfType(system, ecsrx.systems.IManualSystem)) {
					var manualSystem:ecsrx.systems.IManualSystem = cast system;
					manualSystem.update(dt);
				}
			}
		}
	}

	override function dispose() {
		super.dispose();
		if (_ecsApp != null) {
			_ecsApp.dispose();
		}
	}

	static function main() {
		new TestMain();
	}
}