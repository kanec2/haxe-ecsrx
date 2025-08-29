package ecsrx.systems;

abstract class AbstractSetupSystem extends AbstractSystem implements ISetupSystem {
	public function new(?name:String, ?priority:Int) {
		super(name, priority);
	}

	override public function startSystem():Void {
		super.startSystem();
		setup();
	}

	public abstract function setup():Void;
}