package ecsrxe;

import systemsrx.infrastructure.ISystemsRxApplication;
import ecsrxe.collections.database.IEntityDatabase;
import ecsrxe.collections.groups.IObservableGroupManager;

/** 
 * Acts as an entry point and bootstrapper for the ECSRx framework. 
 * Extends SystemsRx application with ECS-specific functionality. 
 */
interface IEcsRxApplication extends ISystemsRxApplication {
	/** 
	 * The entity database, allows you to create and manage entity collections 
	 */
	var entityDatabase(default, null):IEntityDatabase;

	/** 
	 * The observable group manager, allows you to get observable groups 
	 */
	var observableGroupManager(default, null):IObservableGroupManager;
}