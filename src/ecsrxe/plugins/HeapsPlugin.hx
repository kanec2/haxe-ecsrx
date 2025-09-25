package ecsrx.plugins;

import ecsrx.framework.IEcsRxApplication;
import h2d.Scene;
import h2d.Sprite;
import h2d.Tile;
import h3d.mat.Texture;
import h2d.Bitmap;

class HeapsPlugin implements IEcsRxPlugin {
	public var pluginName:String = "HeapsPlugin";

	private var _scene:h2d.Scene;
	private var _spriteCache:Map<Int, h2d.Sprite> = new Map();
	private var _textureCache:Map<String, h2d.Tile> = new Map();

	public function new(scene:h2d.Scene) {
		this._scene = scene;
	}

	public function beforeApplicationStarts(application:IEcsRxApplication):Void {
		trace("Heaps plugin initializing...");
		createDefaultTextures();
		// Можно зарегистрировать Scene в DI контейнере, если будет
	}

	private function createDefaultTextures():Void {
		// Создаем простые текстуры программно для тестирования
		createColoredTexture("player.png", 0x00FF00); // Зеленый для игрока
		createColoredTexture("enemy.png", 0xFF0000); // Красный для врагов
		createColoredTexture("default.png", 0xFFFFFF); // Белый по умолчанию
	}

	private function createColoredTexture(name:String, color:Int):Void {
		if (_textureCache.exists(name))
			return;
		var texture = new Texture(32, 32, [Target]);
		texture.clear(color);
		var tile = Tile.fromTexture(texture);
		_textureCache.set(name, tile);
	}

	public function afterApplicationStarts(application:IEcsRxApplication):Void {
		trace("Heaps plugin initialized");
	}

	public function beforeApplicationStops(application:IEcsRxApplication):Void {
		// Очистка спрайтов
		for (sprite in _spriteCache) {
			sprite.remove();
		}
		_spriteCache.clear();
		_textureCache.clear();
	}

	public function afterApplicationStops(application:IEcsRxApplication):Void {
		trace("Heaps plugin stopped");
	}

	public function getScene():h2d.Scene {
		return _scene;
	}

	public function getOrCreateSprite(id:Int, texture:String):h2d.Sprite {
		if (!_spriteCache.exists(id)) {
			// var sprite = new h2d.Sprite(_scene);
			// Здесь будет загрузка текстуры
			try {
				var tile = getTexture(texture);
				var bitmap = new h2d.Bitmap(tile, _scene);
				_spriteCache.set(id, bitmap);
			} catch (e:Dynamic) {
				trace("Could not load texture: " + texture);
			}
			// _spriteCache.set(id, sprite);
		}
		return _spriteCache.get(id);
	}

	private function getTexture(name:String):h2d.Tile {
		if (_textureCache.exists(name)) {
			return _textureCache.get(name);
		}
		// Если текстура не найдена, используем дефолтную
		if (_textureCache.exists("default.png")) {
			return _textureCache.get("default.png");
		}
		// Создаем дефолтную текстуру
		createColoredTexture("default.png", 0x808080);
		return _textureCache.get("default.png");
	}

	public function removeSprite(id:Int):Void {
		if (_spriteCache.exists(id)) {
			var bitmap = _spriteCache.get(id);
			bitmap.remove();
			_spriteCache.remove(id);
		}
	}

	public function updateSpritePosition(id:Int, x:Float, y:Float, textureName:String, width:Float = 32, height:Float = 32):Void {
		var bitmap = getOrCreateSprite(id, textureName);
		bitmap.x = x;
		bitmap.y = y;
		// Масштабируем если нужно
		bitmap.scaleX = width / 32;
		bitmap.scaleY = height / 32;
	}
}