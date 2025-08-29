
import hxd.App;
import examples.GameApplication;

class Main extends App {
	private var _gameApp:GameApplication;

	override function init() {
		super.init();
		// Создаем и запускаем игру
		var tf = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
		tf.text = "Hello Hashlink !";
		// _gameApp = new GameApplication();
	}

	override function update(dt:Float) {
		super.update(dt);
		// Обновляем игру
		// if (_gameApp != null) {
		//	_gameApp.update(dt);
		// }
	}

	override function dispose() {
		super.dispose();
		// if (_gameApp != null) {
		//	_gameApp.dispose();
		// }
	}

	static function main() {
		new Main();
	}
}