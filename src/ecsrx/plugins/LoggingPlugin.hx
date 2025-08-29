package ecsrx.plugins;

import ecsrx.framework.IEcsRxApplication;
import hlog.Logger;
import hlog.LogLevel;

class LoggingPlugin implements IEcsRxPlugin {
	public var pluginName:String = "LoggingPlugin";

	private var _logger:Logger;
	private var _logLevel:LogLevel;

	public function new(?logLevel:LogLevel) {
		this._logLevel = logLevel != null ? logLevel : LogLevel.INFO;
	}

	public function beforeApplicationStarts(application:IEcsRxApplication):Void {
		// Настройка логгера
		_logger = new Logger("EcsRx");
		_logger.level = _logLevel;
		// Регистрируем в DI
		application.dependencyContainer.bind().to(_logger).asSingleton();
		// Логируем запуск
		_logger.info("EcsRx application starting...");
	}

	public function afterApplicationStarts(application:IEcsRxApplication):Void {
		_logger.info("EcsRx application started successfully");
	}

	public function beforeApplicationStops(application:IEcsRxApplication):Void {
		_logger.info("EcsRx application stopping...");
	}

	public function afterApplicationStops(application:IEcsRxApplication):Void {
		_logger.info("EcsRx application stopped");
		_logger = null;
	}
}