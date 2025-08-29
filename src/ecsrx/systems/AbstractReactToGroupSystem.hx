package ecsrx.systems;

import ecsrx.collections.ICollection;
import rx.Subscription;
import rx.Observable;

abstract class AbstractReactToGroupSystem extends AbstractSystem implements IReactToGroupSystem {
	private var _subscription:Subscription;

	public function new(?name:String, ?priority:Int) {
		super(name, priority);
	}

	override public function startSystem():Void {
		super.startSystem();
		var observable = reactToGroup();
		if (observable != null) {
			_subscription = observable.subscribe(onGroupProcessed);
		}
	}

	override public function stopSystem():Void {
		if (_subscription != null) {
			_subscription.unsubscribe();
			_subscription = null;
		}
		super.stopSystem();
	}

	private function onGroupProcessed(collection:ICollection):Void {
		if (enabled) {
			process(collection);
		}
	}

	abstract public function reactToGroup():Observable<ICollection>;

	abstract public function process(collection:ICollection):Void;
}