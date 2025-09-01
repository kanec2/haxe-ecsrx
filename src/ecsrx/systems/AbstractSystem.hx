package ecsrx.systems;

class AbstractSystem implements ISystem {
	public var systemName:String;
	public var priority:Int = 0;
	public var enabled:Bool = true;

	public function new(?name:String, ?priority:Int) {
		this.systemName = name != null ? name : Type.getClassName(Type.getClass(this));
		if (priority != null)
			this.priority = priority;
	}

	public function startSystem():Void
	{
		trace('System ${systemName} started');
	}

    public function stopSystem():Void
	{
		trace('System ${systemName} stopped');
	}
}