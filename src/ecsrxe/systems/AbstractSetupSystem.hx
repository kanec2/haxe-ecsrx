package ecsrx.systems;

class AbstractSetupSystem extends AbstractSystem implements ISetupSystem {
	public function new(?name:String, ?priority:Int) {
		super(name, priority);
	}

	public override function startSystem():Void {
		setup();
	}

	public override function stopSystem():Void{

	}

	// Абстрактный метод - должен быть реализован в подклассах
	public function setup():Void {
		// Это базовая реализация, которая будет переопределена
		throw "setup() method must be implemented in subclass";
	}
}