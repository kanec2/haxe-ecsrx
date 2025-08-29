package examples;

// Компонент позиции
class PositionComponent {
	public var x:Float;
	public var y:Float;

	public function new(x:Float = 0, y:Float = 0) {
		this.x = x;
		this.y = y;
	}
}

// Компонент здоровья
class HealthComponent {
	public var maxHealth:Int;
	public var currentHealth:Int;

	public function new(health:Int = 100) {
		this.maxHealth = health;
		this.currentHealth = health;
	}

	public function isDead():Bool {
		return currentHealth <= 0;
	}

	public function takeDamage(damage:Int):Void {
		currentHealth -= damage;
		if (currentHealth < 0)
			currentHealth = 0;
	}

	public function heal(amount:Int):Void {
		currentHealth += amount;
		if (currentHealth > maxHealth)
			currentHealth = maxHealth;
	}
}

// Компонент игрока
class PlayerComponent {
	public var score:Int = 0;
	public var level:Int = 1;

	public function new() {}
}

// Компонент врага
class EnemyComponent {
	public var damage:Int;
	public var speed:Float;

	public function new(damage:Int = 10, speed:Float = 1.0) {
		this.damage = damage;
		this.speed = speed;
	}
}

// Компонент рендеринга
class SpriteComponent {
	public var texture:String;
	public var width:Float;
	public var height:Float;

	public function new(texture:String, width:Float = 32, height:Float = 32) {
		this.texture = texture;
		this.width = width;
		this.height = height;
	}
}