package ecsrxe.infrastructure;

import systemsrx.infrastructure.SystemsRxApplication;
import systemsrx.infrastructure.extensions.ISystemsRxApplicationExtensions;
import ecsrxe.collections.IEntityCollection;
import ecsrxe.collections.database.IEntityDatabase;
import ecsrxe.collections.groups.IObservableGroupManager;
import ecsrxe.infrastructure.modules.EcsRxInfrastructureModule;
import ecsrxe.IEcsRxApplication;

/** 
 * Abstract base class for EcsRx applications. 
 * Extends SystemsRx application with ECS-specific functionality. 
 */
@:keep
abstract class EcsRxApplication extends SystemsRxApplication implements IEcsRxApplication {
	public var entityDatabase(default, null):IEntityDatabase;
	public var observableGroupManager(default, null):IObservableGroupManager;

	/** 
	 * Load any modules that your application needs. 
	 * If you wish to use the default setup call through to base, 
	 * if you wish to stop the default framework modules loading 
	 * then do not call base and register your own internal framework module. 
	 */
	override function loadModules():Void {
		// Вызываем базовую реализацию для загрузки модулей SystemsRx
		super.loadModules();

		// Загружаем модуль инфраструктуры EcsRx
		// В C# это было: DependencyRegistry.LoadModule(new EcsRxInfrastructureModule());
		// В Haxe это будет:
		dependencyRegistry.loadModule(new EcsRxInfrastructureModule());
	}

	/** 
	 * Resolve any dependencies the application needs. 
	 * By default it will setup IEntityDatabase, IObservableGroupManager and base class dependencies. 
	 */
	override function resolveApplicationDependencies():Void {
		// Вызываем базовую реализацию для разрешения зависимостей SystemsRx
		super.resolveApplicationDependencies();

		// Разрешаем зависимости ECSRx
		// В C# это было: EntityDatabase = DependencyResolver.Resolve<IEntityDatabase>();
		// В Haxe это будет:
		entityDatabase = dependencyResolver.resolve(IEntityDatabase);

		// В C# это было: ObservableGroupManager = DependencyResolver.Resolve<IObservableGroupManager>();
		// В Haxe это будет:
		observableGroupManager = dependencyResolver.resolve(IObservableGroupManager);
	}
}