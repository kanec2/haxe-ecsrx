package ecsrx.systems;

import ecsrx.systems.AbstractSystem;
import hlog.Logger;

class LoggingSystem extends AbstractSystem {
	private var _logger:Logger;

	public function new(logger:Logger) {
		super("LoggingSystem", -1000);
		// Низкий приоритет
		this._logger = logger;
	}

	override public function startSystem():Void {
		super.startSystem();
		_logger.debug("Logging system started");
	}

	override public function stopSystem():Void {
		_logger.debug("Logging system stopped");
		super.stopSystem();
	}

	public function logInfo(message:String):Void {
		_logger.info(message);
	}

	public function logDebug(message:String):Void {
		_logger.debug(message);
	}

	public function logError(message:String):Void {
		_logger.error(message);
	}
}