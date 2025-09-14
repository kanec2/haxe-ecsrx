
package tests.systemsrx.handlers; 
 
import utest.Assert; 
import utest.Test; 
import systemsrx.executor.handlers.conventional.ReactiveSystemHandler; 
import tests.mocks.*; 
 
/** 
 * Tests for ReactiveSystemHandler, adapted from SystemsRx.Tests.SystemsRx.Handlers.ReactiveSystemHandlerTests 
 */ 
class ReactiveSystemHandlerTest extends Test { 
 
 public function test_should_correctly_handle_systems() { 
    var reactiveSystemHandler = new ReactiveSystemHandler(); 
    
    var fakeMatchingSystem = new FakeReactiveSystem<Int>(); 
    var fakeNonMatchingSystem1 = new tests.mocks.FakeBasicSystem(); 
    var fakeNonMatchingSystem2 = new FakeSystem(); 
    // Простой объект, не реализующий нужные интерфейсы 
    
    Assert.isTrue(reactiveSystemHandler.canHandleSystem(fakeMatchingSystem)); 
    Assert.isFalse(reactiveSystemHandler.canHandleSystem(fakeNonMatchingSystem1)); 
    Assert.isFalse(reactiveSystemHandler.canHandleSystem(fakeNonMatchingSystem2)); 
 } 
 
 public function test_should_setup_and_execute_system() { 
 var reactiveSystemHandler = new ReactiveSystemHandler(); 
 
 var fakeSystem = new FakeReactiveSystem<String>(); 
 reactiveSystemHandler.setupSystem(fakeSystem); 
 
 // Симулируем данные 
 var testData = "Reactive Data"; 
 fakeSystem.dataSubject.on_next(testData); 
 
 Assert.equals(1, fakeSystem.executeCount); 
 Assert.equals(1, fakeSystem.executedData.length); 
 Assert.equals(testData, fakeSystem.executedData[0]); 
 } 
 
 public function test_should_destroy_and_cleanup_system() { 
 var reactiveSystemHandler = new ReactiveSystemHandler(); 
 
 var fakeSystem = new FakeReactiveSystem<Int>(); 
 reactiveSystemHandler.setupSystem(fakeSystem); 
 
 // Убедимся, что система настроена 

 Assert.equals(1, [for (k in reactiveSystemHandler.systemSubscriptions.keys()) k].length);
 reactiveSystemHandler.destroySystem(fakeSystem); 
 
 // Проверяем, что подписка удалена 
 Assert.equals(0, [for (k in reactiveSystemHandler.systemSubscriptions.keys()) k].length);

 } 
}