package tests.mocks;

import systemsrx.events.IEventSystem;
import Type;
#if (threads || sys)
import rx.Observable;
import rx.Subject;
import rx.disposables.ISubscription;
#end

/** 
 * Fake implementation of IEventSystem for testing purposes. 
 * Modified to accept a prototype object to infer the type T for receive<T>(). 
 */
class FakeEventSystem implements IEventSystem {
	#if (threads || sys)
	var subjects:Map<String, Subject<Dynamic>>;
	#end

	public function new() {
		#if (threads || sys)
		subjects = new Map<String, Subject<Dynamic>>();
		#end
	}

	public function publish<T>(message:T):Void {
		#if (threads || sys)
		var typeName = getTypeName(message);
		if (subjects.exists(typeName)) {
			var subject:Subject<Dynamic> = subjects.get(typeName);
			if (subject != null) {
				subject.on_next(message);
			}
		}
		#end
	}

	public function publishAsync<T>(message:T):Void {
		// Для простоты делаем синхронно
		publish(message);
	}

	#if (threads || sys)
	public function receive<T>(prototype:T):Observable<T> {
		// Получаем имя типа из прототипа
		var typeName = getTypeName(prototype);

		if (!subjects.exists(typeName)) {
			subjects.set(typeName, new rx.Subject<Dynamic>());
		}

		var subject:Subject<Dynamic> = subjects.get(typeName);
		return cast subject;
	}
	#else
	public function receive<T>(prototype:T):Observable<T> {
		return null;
	}
	#end

	public function dispose():Void {
		#if (threads || sys)
		for (subject in subjects) {
			if (subject != null) {
				subject.on_completed();
			}
		}
		subjects.clear();
		#end
	}

	// Вспомогательные методы для тестов
	#if (threads || sys)
	public function simulateEvent<T>(event:T):Void {
		publish(event);
	}

	// УПРОЩЕНИЕ: Используем Std.is для определения типа
	function getTypeName(obj:Dynamic):String {
		if (obj == null) {
			return "null";
		}

		// Проверяем типы в порядке от более конкретных к более общим
		if (Std.is(obj, Bool)) {
			return "Bool";
		} else if (Std.is(obj, Int)) {
			return "Int";
		} else if (Std.is(obj, Float)) {
			return "Float";
		} else if (Std.is(obj, String)) {
			return "String";
		} else {
			// Для объектов получаем имя класса
			var cls = Type.getClass(obj);
			if (cls != null) {
				return Type.getClassName(cls);
			}
			// Для перечислений
			var e = Type.getEnum(obj);
			if (e != null) {
				return Type.getEnumName(e);
			}
			// Для функций
			if (Reflect.isFunction(obj)) {
				return "Function";
			}
			// Неизвестный тип
			return "Unknown";
		}
	}
	#end
}