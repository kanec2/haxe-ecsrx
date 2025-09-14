
package tests.mocks; 
 
import systemsrx.systems.conventional.IReactToEventSystem; 
import rx.Observable; 
import rx.Subject; 
 
class FakeReactToEventSystem<T> implements IReactToEventSystem<T> { 
 public var processedEvents:Array<T> = []; 
 public var processCount:Int = 0; 
 public var eventSubject:Subject<T>; 
 
 public function new() { 
 eventSubject = new rx.Subject<T>(); 
 } 
 
 public function process(eventData:T):Void { 
 processedEvents.push(eventData); 
 processCount++; 
 } 
 
 public function reactTo():Observable<T> { 
 return eventSubject; 
 } 
}