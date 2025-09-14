
package tests.systemsrx.handlers; 
 
import utest.Assert; 
import utest.Test; 
import systemsrx.executor.handlers.conventional.ReactToEventSystemHandler; 
import tests.mocks.FakeEventSystem; 
import tests.mocks.*; 
 
/** 
 * Tests for ReactToEventSystemHandler, adapted from SystemsRx.Tests.SystemsRx.Handlers.ReactToEventSystemHandlerTests 
 */ 
class ReactToEventSystemHandlerTest extends Test { 
 
 public function test_should_correctly_handle_systems() { 
 var fakeEventSystem = new FakeEventSystem(); 
 var reactToEventSystemHandler = new ReactToEventSystemHandler(fakeEventSystem); 
 
 var fakeMatchingSystem = new FakeReactToEventSystem<Int>(); 
 var fakeNonMatchingSystem1 = new tests.mocks.FakeBasicSystem(); 
 var fakeNonMatchingSystem2 = new FakeSystem();// Простой объект, не реализующий нужные интерфейсы 
 
 Assert.isTrue(reactToEventSystemHandler.canHandleSystem(fakeMatchingSystem)); 
 Assert.isFalse(reactToEventSystemHandler.canHandleSystem(fakeNonMatchingSystem1)); 
 Assert.isFalse(reactToEventSystemHandler.canHandleSystem(fakeNonMatchingSystem2)); 
 } 
 
 public function test_should_setup_and_process_events() { 
 var fakeEventSystem = new FakeEventSystem(); 
 var reactToEventSystemHandler = new ReactToEventSystemHandler(fakeEventSystem); 
 
 var fakeSystem = new FakeReactToEventSystem<String>(); 
 reactToEventSystemHandler.setupSystem(fakeSystem); 
 
 // Симулируем событие 
 var testEvent = "Hello World"; 
 fakeSystem.eventSubject.on_next(testEvent); 
 
 Assert.equals(1, fakeSystem.processCount); 
 Assert.equals(1, fakeSystem.processedEvents.length); 
 Assert.equals(testEvent, fakeSystem.processedEvents[0]); 
 } 
 
 public function test_should_destroy_and_cleanup_system() { 
 var fakeEventSystem = new FakeEventSystem(); 
 var reactToEventSystemHandler = new ReactToEventSystemHandler(fakeEventSystem); 
 
 var fakeSystem = new FakeReactToEventSystem<Int>(); 
 reactToEventSystemHandler.setupSystem(fakeSystem); 
 
 // Убедимся, что система настроена 

 Assert.equals(1, [for (k in reactToEventSystemHandler.systemSubscriptions.keys()) k].length);
 reactToEventSystemHandler.destroySystem(fakeSystem); 
 
 // Проверяем, что подписка удалена 

 Assert.equals(0, [for (k in reactToEventSystemHandler.systemSubscriptions.keys()) k].length);
 } 
}