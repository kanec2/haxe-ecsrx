package ecsrx.types;

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