
package tests.mocks; 
 
import systemsrx.scheduling.IUpdateScheduler; 
import systemsrx.scheduling.ElapsedTime; 
import rx.Observable; 
import rx.Subject; 
import rx.disposables.ISubscription; 
 
class FakeUpdateScheduler implements IUpdateScheduler { 
 public var elapsedTime(get, null):ElapsedTime; 
 public var onUpdate(get, null):Observable<ElapsedTime>; 
 public var onPreUpdate(get, null):Observable<ElapsedTime>; 
 public var onPostUpdate(get, null):Observable<ElapsedTime>; 
 
 var _elapsedTime:ElapsedTime; 
 var _onUpdateSubject:Subject<ElapsedTime>; 
 var _onPreUpdateSubject:Subject<ElapsedTime>; 
 var _onPostUpdateSubject:Subject<ElapsedTime>; 
 
 public function new() { 
 _elapsedTime = new ElapsedTime(0, 0); 
 _onUpdateSubject = new rx.Subject<ElapsedTime>(); 
 _onPreUpdateSubject = new rx.Subject<ElapsedTime>(); 
 _onPostUpdateSubject = new rx.Subject<ElapsedTime>(); 
 } 
 
 function get_elapsedTime():ElapsedTime { 
 return _elapsedTime; 
 } 
 
 function get_onUpdate():Observable<ElapsedTime> { 
 return _onUpdateSubject; 
 } 
 
 function get_onPreUpdate():Observable<ElapsedTime> { 
 return _onPreUpdateSubject; 
 } 
 
 function get_onPostUpdate():Observable<ElapsedTime> { 
 return _onPostUpdateSubject; 
 } 
 
 public function dispose():Void { 
 _onUpdateSubject.on_completed(); 
 _onPreUpdateSubject.on_completed(); 
 _onPostUpdateSubject.on_completed(); 
 } 
 
 // Вспомогательные методы для тестов 
 public function simulateUpdate(deltaTime:Float = 0.016):Void { 
 _elapsedTime = new ElapsedTime(deltaTime, _elapsedTime.totalTime + deltaTime); 
 _onPreUpdateSubject.on_next(_elapsedTime); 
 _onUpdateSubject.on_next(_elapsedTime); 
 _onPostUpdateSubject.on_next(_elapsedTime); 
 } 
}