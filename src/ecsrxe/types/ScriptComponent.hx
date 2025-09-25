package ecsrx.types;

class ScriptComponent {
	public var scriptCode:String; // Встроенный скрипт
	public var scriptPath:String; // Путь к файлу скрипта
	public var enabled:Bool = true; // Включен ли скрипт

	public function new(?scriptCode:String, ?scriptPath:String) {
		this.scriptCode = scriptCode;
		this.scriptPath = scriptPath;
	}

	public function setScriptCode(code:String):Void {
		this.scriptCode = code;
		this.scriptPath = null;
	}

	public function setScriptPath(path:String):Void {
		this.scriptPath = path;
		this.scriptCode = null;
	}
}