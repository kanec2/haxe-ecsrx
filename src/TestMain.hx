import ecsrx.framework.EcsRxApplication;
import ecsrx.entities.Entity;
import ecsrx.systems.examples.*;
import ecsrx.plugins.CorePlugin;

class TestMain {
	public static function main() {
		trace("Starting EcsRx test...");
		var app = new EcsRxApplication();
		// Регистрируем плагин
		app.registerPlugin(new CorePlugin());
		// Создаем коллекцию для тестирования ReactToGroupSystem
		var testCollection = app.collectionManager.createCollection(null, "test");
		// Регистрируем разные типы систем
		var setupSystem = new ExampleSetupSystem(app.entityDatabase);
		var reactToEntitySystem = new ExampleReactToEntitySystem(app.entityDatabase);
		var reactToGroupSystem = new ExampleReactToGroupSystem(testCollection);
		var manualSystem = new ExampleManualSystem();
		app.registerSystem(setupSystem);
		app.registerSystem(reactToEntitySystem);
		app.registerSystem(reactToGroupSystem);
		app.registerSystem(manualSystem);
		// Запускаем приложение
		app.startApplication();
		// Создаем тестовую сущность (это вызовет ReactToEntitySystem)
		var entity = app.entityDatabase.createEntity("TestEntity");
		trace("Created entity: " + entity.name + " with id: " + entity.id);
		// Проверяем работу коллекций
		trace("Collection has " + testCollection.count() + " entities");
		// Имитируем несколько обновлений ManualSystem
		for (i in 0...10) {
			// Вызываем update для Manual систем
			for (system in app.systems) {
				if (system.enabled && Std.isOfType(system, ecsrx.systems.IManualSystem)) {
					var manualSystem:ecsrx.systems.IManualSystem = cast system;
					manualSystem.update(1 / 60);
					// Примерный deltaTime
				}
			}
		}
		app.dispose();
		trace("Test completed successfully!");
	}
}