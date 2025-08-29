package ecsrx.framework;

import ecsrx.plugins.IEcsRxPlugin;
import ecsrx.systems.ISystem;

class FrameworkBuilder {
	private var _configuration:FrameworkConfiguration;
	private var _plugins:Array<IEcsRxPlugin> = [];
	private var _systems:Array<ISystem> = [];

	public function new() {
		this._configuration = new FrameworkConfiguration();
	}

	public function withConfiguration(config:FrameworkConfiguration):FrameworkBuilder {
		this._configuration = config;
		return this;
	}

	public function withPlugin(plugin:IEcsRxPlugin):FrameworkBuilder {
		_plugins.push(plugin);
		return this;
	}

	public function withSystem(system:ISystem):FrameworkBuilder {
		_systems.push(system);
		return this;
	}

	public function build():IEcsRxApplication {
		var application = new EcsRxApplication(_configuration);
		// Регистрируем плагины
		for (plugin in _plugins) {
			application.registerPlugin(plugin);
		}
		// Регистрируем системы
		for (system in _systems) {
			application.registerSystem(system);
		}
		return application;
	}
}