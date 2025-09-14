
package tests.mocks; 
 
import systemsrx.systems.ISystem; 
import systemsrx.systems.conventional.IBasicSystem; 
import systemsrx.systems.conventional.IManualSystem; 
import systemsrx.systems.conventional.IReactToEventSystem; 
import systemsrx.systems.conventional.IReactiveSystem; 
import systemsrx.scheduling.ElapsedTime; 
import rx.Observable; 
import rx.Subject; 
 
class FakeBasicSystem implements IBasicSystem { 
 public var wasExecuted:Bool = false; 
 public var executionCount:Int = 0; 
 public var lastElapsedTime:ElapsedTime = null; 
 
 public function new() {} 
 
 public function execute(elapsedTime:ElapsedTime):Void { 
 wasExecuted = true; 
 executionCount++; 
 lastElapsedTime = elapsedTime; 
 } 
} 
 