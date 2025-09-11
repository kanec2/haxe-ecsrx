package tests.systemsrx.systems;

import systemsrx.systems.ISystem;

// import systemsrx.utils.PriorityUtils; // Если будут использоваться приоритеты

/** 
 * Test systems with different priorities, adapted from SystemsRx.Tests.Systems 
 */
@:priority(100) // High priority
class HighPrioritySystem implements ISystem {
	public function new() {}
}

@:priority(200) // Higher priority
class HighestPrioritySystem implements ISystem {
	public function new() {}
}

@:priority(-10) // Lower than default priority
class LowerThanDefaultPrioritySystem implements ISystem {
	public function new() {}
}