package systemsrx.computeds; /** * A simple unit type to represent a valueless signal, similar to Unit in Rx.NET or Kotlin. */ @:structInit class Unit {

	public static final instance:Unit = {};

	public function new() {}

	public function toString():String {
		return "Unit";
	}

	public function equals(other:Unit):Bool {
		return (other is Unit); // Все экземпляры Unit равны
	}
}