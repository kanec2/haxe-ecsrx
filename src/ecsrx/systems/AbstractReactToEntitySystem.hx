package ecsrx.systems;

import rx.Observer;
import rx.disposables.ISubscription;
import ecsrx.entities.Entity;
//import rx.ISubscription;
import rx.Observable;

class AbstractReactToEntitySystem extends AbstractSystem implements IReactToEntitySystem {
	private var _subscription:ISubscription;

	public function new(?name:String, ?priority:Int) {
		super(name, priority);
	}

	override public function startSystem():Void {
		super.startSystem();
		var observable = reactToEntity();
		if (observable != null) {
			// Используем правильный Observer
			_subscription = observable.subscribe(Observer.create(onEntityProcessed));
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
		return null;
	}

	public function process(entity:Entity):Void {
		
	}
}