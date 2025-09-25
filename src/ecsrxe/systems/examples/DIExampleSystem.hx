package ecsrx.systems.examples;
import ecsrx.systems.AbstractManualSystem;
import ecsrx.entities.IEntityDatabase;
import ecsrx.collections.ICollectionManager;
import ecsrx.di.ServiceContainer;
class DIExampleSystem extends AbstractManualSystem {
  // Зависимости для внедрения 
  public
  var entityDatabase: IEntityDatabase;
  public
  var collectionManager: ecsrx.collections.ICollectionManager;
  public
  var serviceContainer: ServiceContainer;
  public
  function new( ? container: ServiceContainer) {
    super("DIExampleSystem", 10);
    // Внедряем зависимости через контейнер 
    if (container != null) {
      this.serviceContainer = container;
      this.entityDatabase = container.resolve(ecsrx.entities.IEntityDatabase);
      this.collectionManager = container.resolve(ecsrx.collections.ICollectionManager);
    }
  }
  override public
  function update(elapsedTime: Float) : Void {
    if (entityDatabase != null) {
      var entityCount = entityDatabase.getEntities().length;
      // trace('DI System: ${entityCount} entities in database'); 
    }
  }
  override public
  function startSystem() : Void {
    super.startSystem();
    trace("DI Example System started");
    if (entityDatabase != null) {
      trace("EntityDatabase successfully resolved");
    }
  }
  override public
  function stopSystem() : Void {
    trace("DI Example System stopped");
    super.stopSystem();
  }
}