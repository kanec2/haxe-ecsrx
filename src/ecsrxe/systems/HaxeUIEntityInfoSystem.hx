package ecsrx.systems;

import ecsrx.systems.AbstractReactToEntitySystem;
import ecsrx.entities.Entity;
import ecsrx.plugins.HaxeUIPlugin;
import haxe.ui.components.Label;
import haxe.ui.containers.VBox;
import rx.Observable;

class HaxeUIEntityInfoSystem extends AbstractReactToEntitySystem {
	private var _entityDatabase:ecsrx.entities.IEntityDatabase;
	private var _haxeUIPlugin:HaxeUIPlugin;
	private var _entityInfoPanel:VBox;

	public function new(entityDatabase:ecsrx.entities.IEntityDatabase, haxeUIPlugin:HaxeUIPlugin) {
		super("HaxeUIEntityInfoSystem", 1250);
		this._entityDatabase = entityDatabase;
		this._haxeUIPlugin = haxeUIPlugin;
		createEntityInfoPanel();
	}

	private function createEntityInfoPanel():Void {
		var root = _haxeUIPlugin.getRootComponent();
		if (root == null)
			return;
		_entityInfoPanel = new VBox();
		_entityInfoPanel.width = 300;
		_entityInfoPanel.height = 300;
		_entityInfoPanel.style.backgroundColor = 0x000000;
		_entityInfoPanel.style.opacity = 0.8;
		_entityInfoPanel.right = 10;
		_entityInfoPanel.top = 10;
		var titleLabel = new Label();
		titleLabel.text = "Entity Info";
		titleLabel.style.fontSize = 16;
		titleLabel.style.color = 0xFFFFFF;
		_entityInfoPanel.addComponent(titleLabel);
		root.addComponent(_entityInfoPanel);
	}

	override public function reactToEntity():Observable<Entity> {
		// Реагируем на добавление всех сущностей
		return _entityDatabase.entityAdded();
	}

	override public function process(entity:Entity):Void {
		updateEntityInfo(entity);
	}

	private function updateEntityInfo(entity:Entity):Void {
		if (_entityInfoPanel == null)
			return;
		// Создаем или обновляем информацию о сущности
		var entityLabel = new Label();
		entityLabel.text = 'Entity ${entity.id}: ${entity.name}';
		entityLabel.style.color = 0xFFFFFF;
		entityLabel.style.fontSize = 12;
		// Добавляем информацию о компонентах
		var componentsInfo = "Components: ";
		var componentNames = [];
		// Получаем все компоненты (простой способ)
		var components = entity.getAllComponents();
		for (component in components) {
			if (component != null) {
				var componentName = Type.getClassName(Type.getClass(component));
				componentNames.push(componentName.split(".").pop());
				// Только имя класса
			}
		}
		componentsInfo += componentNames.join(", ");
		var componentsLabel = new Label();
		componentsLabel.text = componentsInfo;
		componentsLabel.style.color = 0xCCCCCC;
		componentsLabel.style.fontSize = 10;
		_entityInfoPanel.addComponent(entityLabel);
		_entityInfoPanel.addComponent(componentsLabel);
		// Ограничиваем количество отображаемых сущностей
		if (_entityInfoPanel.numComponents > 20) {
			_entityInfoPanel.removeComponentAt(2);
			// Удаляем старую информацию
			_entityInfoPanel.removeComponentAt(2);
		}
	}

	override public function stopSystem():Void {
		if (_entityInfoPanel != null) {
			_entityInfoPanel.removeFromParent();
			_entityInfoPanel = null;
		}
		super.stopSystem();
	}
}