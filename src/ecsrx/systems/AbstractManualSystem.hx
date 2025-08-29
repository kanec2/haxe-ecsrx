package ecsrx.systems;

abstract class AbstractManualSystem extends AbstractSystem implements IManualSystem {
	public function new(?name:String, ?priority:Int) {
		super(name, priority);
	}

	abstract public function update(elapsedTime:Float):Void;
}