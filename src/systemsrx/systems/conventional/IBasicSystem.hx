package systemsrx.systems.conventional;

import systemsrx.systems.ISystem;
import systemsrx.scheduling.ElapsedTime; /** * A system which processes every entity every update. * This relies upon the underlying IObservableScheduler implementation and * is by default aiming for 60 updates per second. */ interface IBasicSystem extends ISystem {/** * The method to execute every update. */ function execute(elapsedTime:ElapsedTime):Void;

}