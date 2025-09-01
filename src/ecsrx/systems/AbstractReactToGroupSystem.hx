package ecsrx.systems;

import ecsrx.collections.ICollection;
import rx.disposables.ISubscription;
import rx.Observable;
import rx.Observer;

class AbstractReactToGroupSystem extends AbstractSystem implements IReactToGroupSystem {
	private var _subscription:ISubscription;

	public function new(?name:String, ?priority:Int) {
		super(name, priority);
	}

	override public function startSystem():Void {
		super.startSystem();
		var observable = reactToGroup();
		if (observable != null) {
			_subscription = observable.subscribe(Observer.create(onGroupProcessed));
		}
	}

	override public function stopSystem():Void {
		if (_subscription != null) {
			try {
				_subscription.unsubscribe();
			} catch (e:Dynamic) {
				trace("Error unsubscribing from system: " + e);
			}
			_subscription = null;
		}
		super.stopSystem();
	}

	private function onGroupProcessed(collection:ICollection):Void {
		if (enabled) {
			process(collection);
		}
	}

	public function reactToGroup():Observable<ICollection> {
		return null;
	}

	public function process(collection:ICollection):Void {
		
	}
}