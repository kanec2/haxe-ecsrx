package systemsrx.systems.conventional;

/** * Manual systems are the most basic system where you are provided * a start and stop method which are run when the system is first * registered, and the stop for when the system is removed. */
interface IManualSystem extends ISystem {
	/** * Run when the system has been registered */
	function startSystem():Void;

	/** * Run when the system has been removed */
	function stopSystem():Void;
}