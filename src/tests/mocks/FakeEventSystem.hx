
package tests.mocks; 
 
import systemsrx.events.IEventSystem; 
import rx.Observable; 
import rx.Subject; 
import rx.disposables.ISubscription; 
 
class FakeEventSystem implements IEventSystem { 
 var subjects:Map<String, Subject<Dynamic>>; 
 
 public function new() { 
 subjects = new Map<String, Subject<Dynamic>>(); 
 } 
 
 public function publish<T>(message:T):Void { 
 var typeName = Type.getClassName(Type.getClass(message)); 
 if (subjects.exists(typeName)) { 
 subjects.get(typeName).on_next(message); 
 } 
 } 
 
 public function publishAsync<T>(message:T):Void { 
 // Для простоты делаем синхронно 
 publish(message); 
 } 
 
 // ИСПРАВЛЕНИЕ: Вместо использования T напрямую, принимаем Class<T> как параметр 
 public function receive<T>(type:Class<T>):Observable<T> { 
 // ИСПРАВЛЕНИЕ: Получаем имя типа из Class<T> 
 var typeName = Type.getClassName(type); 
 if (!subjects.exists(typeName)) { 
 // ИСПРАВЛЕНИЕ: Создаем Subject с правильным типом 
 subjects.set(typeName, new rx.Subject<Dynamic>()); 
 } 
 // ИСПРАВЛЕНИЕ: Приводим к правильному типу Observable 
 return cast subjects.get(typeName); 
 } 
 
 public function dispose():Void { 
 for (subject in subjects) { 
 subject.on_completed(); 
 } 
 subjects.clear(); 
 } 
 
 // Вспомогательные методы для тестов 
 public function simulateEvent<T>(event:T):Void { 
 publish(event); 
 } 
}