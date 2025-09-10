package systemsrx.microrx.events; #if (threads || sys) import rx.Observable;

import rx.Subject;
import haxe.concurrent.lock.Semaphore;
import Type; #end /** * Message broker implementation for Haxe. */ class MessageBrokerHx implements IMessageBrokerHx /*implements Disposable*/ {#if (threads

	|| sys) public static final defaultInstance:IMessageBrokerHx = new MessageBrokerHx();

	private var isDisposed:Bool = false;
	private final notifiers:Map<String, Dynamic> = new Map<String, Dynamic>();
	private final lock:Semaphore = new Semaphore(1, 1);

	public function new() {}

	public function publish<T>(message:T):Void {
		var notifier:Dynamic = null;
		var typeName:String = null;
		lock.acquire();
		try {
			if (isDisposed)
				return;
			typeName = Type.getClassName(Type.getClass(message));
			notifier = notifiers.get(typeName);
		}
		finally
		{
			lock.release();
		}
		if (notifier != null) {
			var subject:Subject<T> = cast notifier;
			subject.on_next(message);
		}
	}

	public function receive<T>(type:Class<T>):Observable<T> {
		var notifier:Dynamic = null;
		var typeName:String = null;
		lock.acquire();
		try {
			if (isDisposed)
				throw "MessageBroker is disposed";
			typeName = Type.getClassName(type);
			notifier = notifiers.get(typeName);
			if (notifier != null) {
				return cast notifier;
			}
			var n:Subject<T> = new rx.Subject<T>();
			notifier = n;
			notifiers.set(typeName, notifier);
			return cast notifier;
		}
		finally
		{
			lock.release();
		}
	}

	public function dispose():Void {
		lock.acquire();
		try {
			if (isDisposed)
				return;
			isDisposed = true;
			for (notifier in notifiers) {
				if (notifier != null) {
					try {
						var subject:Subject<Dynamic> = cast notifier;
						subject.on_completed();
					} catch (e:Dynamic) {}
				}
			}
			notifiers.clear();
		}
		finally
		{
			lock.release();
		}
	} #else public static final defaultInstance:IMessageBrokerHx = new MessageBrokerHx();

	public function new() {}

	public function publish<T>(message:T):Void {}

	public function receive<T>(type:Class<T>):rx.Observable<T> {
		return null;
	}

	public function dispose():Void {} #end
}