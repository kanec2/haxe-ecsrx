package systemsrx.executor.handlers;

import systemsrx.systems.ISystem;

interface IConventionalSystemHandler {
	function canHandleSystem(system:ISystem):Bool;
	function setupSystem(system:ISystem):Void;
	function destroySystem(system:ISystem):Void;
}