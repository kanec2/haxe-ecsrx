package systemsrx.executor;

import systemsrx.systems.ISystem; /** * Interface for a system executor that manages the lifecycle of systems. */ interface ISystemExecutor {/** * Gets the collection of systems currently managed by the executor. */ var systems(default,

	null):Array<ISystem>; /** * Checks if a system is currently managed by the executor. * @param system The system to check. * @return True if the system is managed by the executor, false otherwise. */ function hasSystem(system:ISystem):Bool; /** * Removes a system from the executor and calls the appropriate destroy methods. * @param system The system to remove. */ function removeSystem(system:ISystem):Void; /** * Adds a system to the executor and calls the appropriate setup methods. * @param system The system to add. */ function addSystem(system:ISystem):Void; /** * Disposes of all systems and resources used by the executor. */ function dispose():Void;

}