
package tests.mocks; 
 
import systemsrx.systems.conventional.IReactiveSystem; 
import rx.Observable; 
import rx.Subject; 
 
class FakeReactiveSystem<T> implements IReactiveSystem<T> { 
 public var executedData:Array<T> = []; 
 public var executeCount:Int = 0; 
 public var dataSubject:Subject<T>; 
 
 public function new() { 
 dataSubject = new rx.Subject<T>(); 
 } 
 
 public function reactTo():Observable<T> { 
 return dataSubject; 
 } 
 
 public function execute(data:T):Void { 
 executedData.push(data); 
 executeCount++; 
 } 
}