
package tests.mocks; 
 
import systemsrx.systems.ISystem; 
import systemsrx.systems.conventional.IManualSystem; 
 
class FakeManualSystem implements IManualSystem { 
 public var wasStarted:Bool = false; 
 public var wasStopped:Bool = false; 
 public var startCount:Int = 0; 
 public var stopCount:Int = 0; 
 
 public function new() {} 
 
 public function startSystem():Void { 
 wasStarted = true; 
 startCount++; 
 } 
 
 public function stopSystem():Void { 
 wasStopped = true; 
 stopCount++; 
 } 
}