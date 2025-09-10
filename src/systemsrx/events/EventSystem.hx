package systemsrx.events;

import rx.Observable;
// Предполагаем, что у нас будут реализации IMessageBroker и IThreadHandler 
// import systemsrx.micro.rx.events.IMessageBroker; 
// import systemsrx.threading.IThreadHandler;


class EventSystem implements IEventSystem {
	// Пока используем заглушки
	public var messageBroker:Dynamic; // IMessageBroker
	public var threadHandler:Dynamic; // IThreadHandler

	private var subjects:Map<String, Dynamic>;

	public function new(messageBroker:Dynamic, threadHandler:Dynamic) { this.messageBroker = messageBroker; this.threadHandler = threadHandler; }

	

	public function publish<T>(message:T):Void {
        // messageBroker.publish(message);
        trace("Publishing message: " + message);
	}

	public function publishAsync<T>(message:T):Void {
        // threadHandler.run(() -> messageBroker.publish(message));
        trace("Publishing message async: " + message);
	}

	public function receive<T>():Observable<T> {
		// return messageBroker.receive<T>();
		return null; // Заглушка
	}
}