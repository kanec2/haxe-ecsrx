package ecsrxe.infrastructure.modules;

import systemsrx.infrastructure.dependencies.IDependencyRegistry;
import systemsrx.infrastructure.dependencies.IDependencyResolver;
import systemsrx.infrastructure.dependencies.IDependencyModule;
import systemsrx.infrastructure.dependencies.BindingConfiguration;
import systemsrx.pools.IIdPool;
import systemsrx.pools.IdPool;
import ecsrxe.collections.entity.IEntityFactory;
import ecsrxe.collections.entity.DefaultEntityFactory;
import ecsrxe.collections.entity.IEntityCollectionFactory;
import ecsrxe.collections.entity.DefaultEntityCollectionFactory;
import ecsrxe.collections.database.IEntityDatabase;
import ecsrxe.collections.database.EntityDatabase;
import ecsrxe.collections.groups.observable.IObservableGroupFactory;
import ecsrxe.collections.groups.observable.DefaultObservableObservableGroupFactory;
import ecsrxe.collections.groups.observable.IObservableGroupManager;
import ecsrxe.collections.groups.observable.ObservableGroupManager;
import ecsrxe.components.database.IComponentTypeAssigner;
import ecsrxe.components.database.DefaultComponentTypeAssigner;
import ecsrxe.components.lookups.IComponentTypeLookup;
import ecsrxe.components.lookups.ComponentTypeLookup;
import ecsrxe.components.database.IComponentDatabase;
import ecsrxe.components.database.ComponentDatabase;
import ecsrxe.collections.groups.observable.tracking.IGroupTrackerFactory;
import ecsrxe.collections.groups.observable.tracking.GroupTrackerFactory;
import ecsrxe.systems.handlers.IConventionalSystemHandler;
import ecsrxe.systems.handlers.conventional.BasicEntitySystemHandler;
import ecsrxe.systems.handlers.conventional.ReactToEntitySystemHandler;
import ecsrxe.systems.handlers.conventional.ReactToGroupSystemHandler;
import ecsrxe.systems.handlers.conventional.ReactToDataSystemHandler;
import ecsrxe.systems.handlers.conventional.SetupSystemHandler;
import ecsrxe.systems.handlers.conventional.TeardownSystemHandler;

/** 
 * Module for registering ECSRx infrastructure dependencies. 
 */
@:keep
class EcsRxInfrastructureModule implements IDependencyModule {
	public function new() {}

	public function setup(registry:IDependencyRegistry):Void {
		// Register ECS specific infrastructure
		registry.bind(IIdPool, IdPool);
		registry.bind(IEntityFactory, DefaultEntityFactory);
		registry.bind(IEntityCollectionFactory, DefaultEntityCollectionFactory);
		registry.bind(IEntityDatabase, EntityDatabase);
		registry.bind(IObservableGroupFactory, DefaultObservableObservableGroupFactory);
		registry.bind(IObservableGroupManager, ObservableGroupManager);
		registry.bind(IComponentTypeAssigner, DefaultComponentTypeAssigner);
		// В Haxe нет прямого эквивалента ToMethod, но можно использовать bind с функцией
		// registry.bind(IComponentTypeLookup, function(resolver:IDependencyResolver):IComponentTypeLookup {
		// return createDefaultTypeLookup(resolver);
		// });
		// Или использовать bindInstance с предварительно созданным экземпляром
		// registry.bindInstance(IComponentTypeLookup, createDefaultTypeLookup(/*resolver*/null)); // resolver будет передан позже
		// Или использовать фабричный метод в registry
		registry.bind(IComponentTypeLookup, createDefaultTypeLookup); // Передаем функцию как фабрику
		registry.bind(IComponentDatabase, ComponentDatabase);
		registry.bind(IGroupTrackerFactory, GroupTrackerFactory);

		// Register ECS specific system handlers
		registry.bind(IConventionalSystemHandler, BasicEntitySystemHandler);
		registry.bind(IConventionalSystemHandler, ReactToEntitySystemHandler);
		registry.bind(IConventionalSystemHandler, ReactToGroupSystemHandler);
		registry.bind(IConventionalSystemHandler, ReactToDataSystemHandler);
		registry.bind(IConventionalSystemHandler, SetupSystemHandler);
		registry.bind(IConventionalSystemHandler, TeardownSystemHandler);
	}

	// В Haxe функция фабрики должна принимать resolver как аргумент
	// или возвращать функцию, которая принимает resolver
	// Используем подход с возвратом функции
	function createDefaultTypeLookup(resolver:IDependencyResolver):IComponentTypeLookup {
		var componentTypeAssigner = resolver.resolve(IComponentTypeAssigner);
		var allComponents = componentTypeAssigner.generateComponentLookups();
		return new ComponentTypeLookup(allComponents);
	}
}