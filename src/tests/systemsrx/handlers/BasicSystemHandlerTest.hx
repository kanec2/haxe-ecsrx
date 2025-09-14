
package tests.systemsrx.handlers; 
 
import utest.Assert; 
import utest.Test; 
import systemsrx.executor.handlers.conventional.BasicSystemHandler; 
import tests.mocks.FakeUpdateScheduler; 
import tests.mocks.*;
 
/** 
 * Tests for BasicSystemHandler, adapted from SystemsRx.Tests.SystemsRx.Handlers.BasicSystemHandlerTests 
 */ 
class BasicSystemHandlerTest extends Test { 
 
 public function test_should_correctly_handle_systems() { 
 var fakeUpdateScheduler = new FakeUpdateScheduler(); 
 var basicSystemHandler = new BasicSystemHandler(fakeUpdateScheduler); 
 
 var fakeMatchingSystem = new FakeBasicSystem(); 
 var fakeNonMatchingSystem1 = new tests.mocks.FakeManualSystem(); 
 var fakeNonMatchingSystem2 = new FakeSystem(); // Реализует ISystem, но не IBasicSystem
 
 Assert.isTrue(basicSystemHandler.canHandleSystem(fakeMatchingSystem)); 
 Assert.isFalse(basicSystemHandler.canHandleSystem(fakeNonMatchingSystem1)); 
 Assert.isFalse(basicSystemHandler.canHandleSystem(fakeNonMatchingSystem2)); 
 } 
 
 public function test_should_setup_and_execute_system() { 
 var fakeUpdateScheduler = new FakeUpdateScheduler(); 
 var basicSystemHandler = new BasicSystemHandler(fakeUpdateScheduler); 
 
 var fakeSystem = new FakeBasicSystem(); 
 basicSystemHandler.setupSystem(fakeSystem); 
 
 // Симулируем обновление 
 fakeUpdateScheduler.simulateUpdate(0.016); 
 
 Assert.isTrue(fakeSystem.wasExecuted); 
 Assert.equals(1, fakeSystem.executionCount); 
 Assert.notNull(fakeSystem.lastElapsedTime); 
 } 
 
 public function test_should_destroy_and_cleanup_system() { 
 var fakeUpdateScheduler = new FakeUpdateScheduler(); 
 var basicSystemHandler = new BasicSystemHandler(fakeUpdateScheduler); 
 
 var fakeSystem = new FakeBasicSystem(); 
 basicSystemHandler.setupSystem(fakeSystem); 
 
 // Убедимся, что система настроена 
 Assert.equals(1, [for (k in basicSystemHandler.systemSubscriptions.keys()) k].length);
 basicSystemHandler.destroySystem(fakeSystem); 
 
 // Проверяем, что подписка удалена 
 Assert.equals(0, [for (k in basicSystemHandler.systemSubscriptions.keys()) k].length);
 } 
}