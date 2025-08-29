package ecsrx.plugins;

import ecsrx.framework.IEcsRxApplication;

class PluginManager {
	private var _plugins:Array<IEcsRxPlugin> = [];
	private var _application:IEcsRxApplication;

	public function new(application:IEcsRxApplication) {
		this._application = application;
	}

	public function loadPlugin(plugin:IEcsRxPlugin):Void {
		if (!_plugins.contains(plugin)) {
			_plugins.push(plugin);
			plugin.beforeApplicationStarts(_application);
		}
	}

	public function unloadPlugin(plugin:IEcsRxPlugin):Void {
		if (_plugins.remove(plugin)) {
			plugin.beforeApplicationStops(_application);
		}
	}

	public function getPlugins():Array<IEcsRxPlugin> {
		return _plugins.copy();
	}

	public function dispose():Void {
		// Выгружаем все плагины в обратном порядке
		var reversedPlugins = _plugins.copy();
		reversedPlugins.reverse();
		for (plugin in reversedPlugins) {
			try {
				plugin.beforeApplicationStops(_application);
			} catch (e:Dynamic) {
				trace('Error unloading plugin ${plugin.pluginName}: $e');
			}
		}
		_plugins = [];
	}
}