package systemsrx.microrx.events;

#if (threads || sys)
import rx.Observable;
import rx.Subject;
import haxe.concurrent.lock.Semaphore;
// Используем Semaphore для синхронизации
import Type;

// Для получения имени типа
#end

/** * Message broker implementation. * This code is adapted from UniRx project by neuecc (https://github.com/neuecc/UniRx). */
class MessageBroker implements IMessageBroker /*implements Disposable*/ {
	#if (threads || sys) /** * MessageBroker in Global scope. */
	public static final defaultInstance:IMessageBroker = new MessageBroker();

	private var isDisposed:Bool = false;
	// Используем Map<String, Dynamic> для хранения Subject'ов разных типов
	private final notifiers:Map<String, Dynamic> = new Map<String, Dynamic>();
	// Семафор для синхронизации доступа к notifiers
	private final lock:Semaphore = new Semaphore(1, 1);

	// Бинарный семафор как Mutex
	public function new() {
		// Конструктор
	}

	public function publish<T>(message:T):Void {
		var notifier:Dynamic = null;
		var typeName:String = null;
		lock.acquire();
		try {
			if (isDisposed) {
				return;
			}
			typeName = Type.getClassName(Type.getClass(message));
			if (typeName == null) {
				// Для базовых типов (Int, String и т.д.)
				typeName = Std.string(Type.typeof(message));
				// Это даст Enum<ValueType>
			}
			notifier = notifiers.get(typeName);
		}
		finally
		{
			lock.release();
		}
		// Отправляем сообщение, если Subject найден
		if (notifier != null) {
			// Приводим к Subject<T> и вызываем on_next
			// В Haxe это безопасно, если мы правильно сохранили тип при добавлении
			var subject:Subject<T> = cast notifier;
			// Используем правильное имя метода из RxHaxe Subject
			subject.on_next(message);
		}
	}

	public function receive<T>():Observable<T> {
		var notifier:Dynamic = null;
		var typeName:String = null;
		lock.acquire();
		try {
			if (isDisposed) {
				// В Haxe нет прямого аналога ObjectDisposedException, бросаем обычное исключение
				throw "MessageBroker is disposed";
			}
			// Получаем имя типа T. Это сложнее в Haxe, так как T - это тип времени компиляции.
			// В C# typeof(T) работает в runtime. В Haxe мы не можем напрямую получить Class<T> из T.
			// Нам нужно, чтобы вызывающая сторона передала тип.
			// Один из способов - сделать receive типизированным статическим методом или использовать макрос.
			// Для упрощения, предположим, что T определяется в контексте вызова.
			// Или используем трюк с передачей "фиктивного" экземпляра T или Class<T>.
			// Пока что оставим заглушку и вернем пустой Observable.
			// Или предположим, что у нас есть способ получить Class<T>.
			// В целях демонстрации, давайте предположим, что у нас есть способ получить тип.
			// Это требует изменения сигнатуры метода или использования макроса.
			// Для простоты сейчас реализуем с использованием рефлексии и предположения.
			// Проблема: в Haxe обобщенный метод receive<T>() не может напрямую получить typeof(T) в runtime.
			// Решения:
			// 1. Изменить сигнатуру: receive<T>(type:Class<T>):Observable<T>
			// 2. Использовать макросы.
			// 3. Использовать статические методы с конкретными типами.
			// Реализуем с измененной сигнатурой (способ 1):
			// function receive<T>(type:Class<T>):Observable<T> - это будет в другом интерфейсе или реализации.
			// Для текущей сигнатуры, предположим, что у нас есть глобальный способ отслеживания типа.
			// Это не будет работать корректно без доработки.
			// Вернем пустой Observable как заглушку.
			// Правильная реализация требует изменения интерфейса или использования макросов.
			// Например, в библиотеках Haxe это часто делается так:
			// receive(MyMessageType) вместо receive()
			// Давайте попробуем реализовать с предположением, что у нас есть способ получить Class<T>
			// Это сложно без изменения сигнатуры. Вернем пустой Observable.
			return Observable.empty();
			/* typeName =
				// Как-то получить имя типа T notifier = notifiers.get(typeName); if (notifier != null) { return cast notifier;
				// cast к Observable<T> } var n:Subject<T> = new rx.Subject<T>();
				// Subject.create<T>() notifier = n; notifiers.set(typeName, notifier); return cast notifier;
				// cast к Observable<T> 
			 */
		}
		finally
		{
			lock.release();
		}
	}

	// Реализация с измененной сигнатурой (более правильный способ в Haxe)

	public function receiveByType<T>(type:Class<T>):Observable<T> {
		var notifier:Dynamic = null;
		var typeName:String = null;
		lock.acquire();
		try {
			if (isDisposed) {
				throw "MessageBroker is disposed";
			}
			typeName = Type.getClassName(type);
			notifier = notifiers.get(typeName);
			if (notifier != null) {
				return cast notifier;
				// cast к Observable<T>
			}
			var n:Subject<T> = new rx.Subject<T>();
			// Subject.create<T>()
			notifier = n;
			notifiers.set(typeName, notifier);
			return cast notifier;
			// cast к Observable<T>
		}
		finally
		{
			lock.release();
		}
	}

	public function dispose():Void {
		lock.acquire();
		try {
			if (isDisposed) {
				return;
			}
			isDisposed = true;
			// Очищаем карту. Subject'ы должны быть завершены.
			for (notifier in notifiers) {
				if (notifier != null) {
					// Проверяем, является ли notifier Subject'ом
					// Это сложно сделать типобезопасно без информации о типе
					try {
						var subject:Subject<Dynamic> = cast notifier;
						subject.on_completed();
						// Завершаем Subject
						// subject.dispose();
						// Если Subject имеет метод dispose
					} catch (e:Dynamic) {
						// Игнорируем ошибки приведения типов
					}
				}
			}
			notifiers.clear();
		}
		finally
		{
			lock.release();
		}
	}
	#else
	// Заглушка для платформ без поддержки
	public static final defaultInstance:IMessageBroker = new MessageBroker();

	public function new() {}

	public function publish<T>(message:T):Void {}

	public function receive<T>():rx.Observable<T> {
		return null;
	}

	public function receiveByType<T>(type:Class<T>):rx.Observable<T> {
		return null;
	}

	public function dispose():Void {}
	#end
}