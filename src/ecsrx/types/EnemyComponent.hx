package ecsrx.types;

class EnemyComponent {
	public var damage:Int;
	public var speed:Float;
	public var attackCooldown:Float = 0;

	public function new(damage:Int = 10, speed:Float = 1.0) {
		this.damage = damage;
		this.speed = speed;
	}
}