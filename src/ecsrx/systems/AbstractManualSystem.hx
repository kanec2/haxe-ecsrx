package ecsrx.systems;

class AbstractManualSystem extends AbstractSystem implements IManualSystem {
	public function new(?name:String, ?priority:Int) {
		super(name, priority);
	}

	public function update(elapsedTime:Float):Void
	{

	}
}