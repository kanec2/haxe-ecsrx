package ecsrx.systems.examples;

import ecsrx.systems.AbstractManualSystem;

class ExampleManualSystem extends AbstractManualSystem {
	private var _updateCount:Int = 0;

	public function new() {
		super("ExampleManualSystem", 50);
	}

	override public function update(elapsedTime:Float):Void {
		_updateCount++;
		if (_updateCount % 60 == 0) {
			// Примерно раз в секунду при 60 FPS
			trace('Manual system update #${_updateCount}, elapsed: ${elapsedTime}');
		}
	}
}