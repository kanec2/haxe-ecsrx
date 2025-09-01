package ecsrx.systems;

abstract class AbstractSystem implements ISystem {
	public var systemName:String;
	public var priority:Int = 0;
	public var enabled:Bool = true;

	public function new(?name:String, ?priority:Int) {
		this.systemName = name != null ? name : Type.getClassName(Type.getClass(this));
		if (priority != null)
			this.priority = priority;
	}

	abstract public function startSystem():Void;
    abstract public function stopSystem():Void;
}