package ecsrx.systems;

interface ISystem {
	var systemName:String;
	var priority:Int;
	var enabled:Bool;
	function startSystem():Void;
	function stopSystem():Void;
}