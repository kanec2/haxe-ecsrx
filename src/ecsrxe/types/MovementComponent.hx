package ecsrx.types;

class MovementComponent {
	public var velocityX:Float = 0;
	public var velocityY:Float = 0;
	public var maxSpeed:Float = 100;

	public function new(maxSpeed:Float = 100) {
		this.maxSpeed = maxSpeed;
	}
}