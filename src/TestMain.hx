import ecsrx.systems.examples.ExampleSetupSystem;
import ecsrx.plugins.CorePlugin;
import ecsrx.framework.EcsRxApplication;
import ecsrx.entities.Entity;

class TestMain {
	public static function main() {
		trace("Starting EcsRx test...");
		var app = new EcsRxApplication();
		// Регистрируем плагин
		app.registerPlugin(new CorePlugin());
		// Регистрируем систему
		var setupSystem = new ExampleSetupSystem(app.entityDatabase);
		app.registerSystem(setupSystem);
		// Запускаем приложение
		app.startApplication();
		// Создаем тестовую сущность
		var entity = app.entityDatabase.createEntity("TestEntity");
		trace("Created entity: " + entity.name + " with id: " + entity.id);
		// Проверяем работу коллекций
		var collection = app.collectionManager.createCollection(null, "test");
		trace("Created collection with " + collection.count() + " entities");
		app.dispose();
		trace("Test completed successfully!");
	}
}