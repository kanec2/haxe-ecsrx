package systemsrx.scheduling;

/** * Represents elapsed time information. */
@:structInit // Позволяет создавать экземпляры с синтаксисом { deltaTime: ..., totalTime: ... }
class ElapsedTime /*implements IEquatable<ElapsedTime>*/ {
	// Haxe не имеет встроенного IEquatable, но мы можем реализовать equals
	public var deltaTime:Float; // Время в секундах или миллисекундах между обновлениями
	public var totalTime:Float; // Общее время с момента запуска

	public function new(deltaTime:Float, totalTime:Float) {
		this.deltaTime = deltaTime;
		this.totalTime = totalTime;
	}

	public function equals(other:ElapsedTime):Bool {
		return other != null && deltaTime == other.deltaTime && totalTime == other.totalTime;
	}

	public function toString():String {
		return 'ElapsedTime(deltaTime: $deltaTime, totalTime: $totalTime)';
	}
}