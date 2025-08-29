import ecsrx.framework.EcsRxApplication;
import ecsrx.entities.Entity;

class TestMain {
	public static function main() {
		trace("Starting EcsRx test...");
		var app = new EcsRxApplication();
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