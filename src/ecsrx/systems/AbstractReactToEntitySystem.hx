package ecsrx.systems;

import ecsrx.entities.Entity;
import rx.Subscription;
import rx.Observable;

class AbstractReactToEntitySystem extends AbstractSystem implements IReactToEntitySystem {
	private var _subscription:Subscription;

	public function new(?name:String, ?priority:Int) {
		super(name, priority);
	}

	override public function startSystem():Void {
		super.startSystem();
		var observable = reactToEntity();
		if (observable != null) {
			_subscription = observable.subscribe(process);
		}
	}

	override public function stopSystem():Void {
		if (_subscription != null) {
			_subscription.unsubscribe();
			_subscription = null;
		}
		super.stopSystem();
	}

	private function onEntityProcessed(entity:Entity):Void {
		if (enabled) {
			process(entity);
		}
	}

	public function reactToEntity():Observable<Entity> {
		throw "reactToEntity() method must be implemented in subclass";
	}

	public function process(entity:Entity):Void {
		throw "process() method must be implemented in subclass";
	}
}