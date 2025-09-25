package ecsrx.systems;

interface IManualSystem extends ISystem {
	function update(elapsedTime:Float):Void;
}