package ecsrx.plugins;

import ecsrx.framework.IEcsRxApplication;
import com.uking.concurrent.ThreadPool;

class ConcurrentPlugin implements IEcsRxPlugin {
	public var pluginName:String = "ConcurrentPlugin";

	private var _threadPool:ThreadPool;
	private var _maxThreads:Int;

	public function new(maxThreads:Int = 4) {
		this._maxThreads = maxThreads;
	}

	public function beforeApplicationStarts(application:IEcsRxApplication):Void {
		// Создаем глобальный пул потоков
		_threadPool = new ThreadPool(_maxThreads);
		// Регистрируем в DI контейнере
		application.dependencyContainer.bind().to(_threadPool).asSingleton();
	}

	public function afterApplicationStarts(application:IEcsRxApplication):Void {
		// Дополнительная настройка
	}

	public function beforeApplicationStops(application:IEcsRxApplication):Void {
		// Завершаем работу пула потоков
		if (_threadPool != null) {
			_threadPool.shutdown();
		}
	}

	public function afterApplicationStops(application:IEcsRxApplication):Void {
		// Финальная очистка
		_threadPool = null;
	}
}