package ecsrx.plugins;

import ecsrx.framework.IEcsRxApplication;
import haxe.ui.Toolkit;
import haxe.ui.core.Component as UIComponent;
import haxe.ui.core.Screen;
//import haxe.ui.backends.heaps.HeapsBackend;


class HaxeUIPlugin implements IEcsRxPlugin {
	public var pluginName:String = "HaxeUIPlugin";

	private var _rootComponent:UIComponent;
	private var _components:Map<String, UIComponent> = new Map();

	public function new() {}

	public function beforeApplicationStarts(application:IEcsRxApplication):Void {
		trace("HaxeUI plugin initializing...");
		#if (haxeui_core && haxeui_heaps)
		initializeHaxeUI();
		#end
	}

	private function initializeHaxeUI():Void {
		try {
			// Инициализация HaxeUI с Heaps бэкендом
			Toolkit.init();
			trace("HaxeUI initialized successfully");
		} catch (e:Dynamic) {
			trace("HaxeUI initialization failed: " + e);
		}
	}

	public function afterApplicationStarts(application:IEcsRxApplication):Void {
		trace("HaxeUI plugin initialized");
		// Создаем базовый UI после запуска приложения
		createDefaultUI();
	}

	private function createDefaultUI():Void {
		try {
			// Создаем корневой компонент
			_rootComponent = new UIComponent();
			_rootComponent.width = 1024;
			_rootComponent.height = 768;
			// Добавляем на экран
			Screen.instance.addComponent(_rootComponent);
			trace("Default UI created");
		} catch (e:Dynamic) {
			trace("UI creation failed: " + e);
		}
	}

	public function beforeApplicationStops(application:IEcsRxApplication):Void {
		// Очистка компонентов
		for (component in _components) {
			try {
				//component.parent.removeComponent(component);
			} catch (e:Dynamic) {
				// Игнорируем ошибки очистки
			}
		}
		_components.clear();
		if (_rootComponent != null) {
			try {
				//_rootComponent.parent.removeComponent(_rootComponent);
			} catch (e:Dynamic) {
				// Игнорируем ошибки очистки
			}
			_rootComponent = null;
		}
	}

	public function afterApplicationStops(application:IEcsRxApplication):Void {
		trace("HaxeUI plugin stopped");
	}

	public function getRootComponent():UIComponent {
		return _rootComponent;
	}

	public function addComponent(name:String, component:UIComponent):Void {
		if (_rootComponent != null) {
			_rootComponent.addComponent(component);
			_components.set(name, component);
		}
	}

	public function removeComponent(name:String):Void {
		if (_components.exists(name)) {
			var component = _components.get(name);
			try { 
				//component.parent.removeComponent(component); 
			} catch (e:Dynamic) { 
				// Игнорируем ошибки
				 }
			_components.remove(name);
		}
	}

	public function getComponent(name:String):UIComponent {
		return _components.get(name);
	}

	public function hasComponent(name:String):Bool {
		return _components.exists(name);
	}
}