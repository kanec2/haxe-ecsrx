package systemsrx.events;

import rx.Observable;

// Предполагаем, что у нас будут реализации IMessageBroker и IThreadHandler
// import systemsrx.micro.rx.events.IMessageBroker;
// import systemsrx.threading.IThreadHandler;
class EventSystem implements IEventSystem {
	// Пока используем заглушки
	public var messageBroker(default, null):IMessageBroker;
	// IMessageBroker
	public var threadHandler(default, null):IThreadHandler;

	// IThreadHandler
	private var subjects:Map<String, Dynamic>;

	public function new(messageBroker:Dynamic, threadHandler:Dynamic) {
		this.messageBroker = messageBroker;
		this.threadHandler = threadHandler;
	}

	public function publish<T>(message:T):Void {
		// messageBroker.publish(message);
		trace("Publishing message: " + message);
	}

	public function publishAsync<T>(message:T):Void {
		// threadHandler.run(() -> messageBroker.publish(message));
		threadHandler.run(() -> messageBroker.publish(message));
	}

	public function receive<T>():Observable<T> {
		// return messageBroker.receive<T>();
		return Observable.empty();
	}

	// Альтернативная реализация receive с явной передачей типа
	public function receiveByType<T>(type:Class<T>):Observable<T> {
		// Если messageBroker поддерживает receive с типом
		if (Std.is(messageBroker, systemsrx.microrx.events.IMessageBrokerHx)) {
			var brokerHx:systemsrx.microrx.events.IMessageBrokerHx = cast messageBroker;
			return brokerHx.receive(type);
		} else {
			// Если это оригинальный MessageBroker, который не поддерживает receive<T>()
			// напрямую, то возвращаем пустой Observable или бросаем исключение.
			// В реальной реализации нужно будет убедиться, что используется правильный брокер.
			return Observable.empty();
		}
	}
}