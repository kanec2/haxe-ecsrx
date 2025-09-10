package systemsrx.scheduling; /** * Interface for tracking elapsed time. */

interface ITimeTracker {
	var elapsedTime(get, null):ElapsedTime;
}