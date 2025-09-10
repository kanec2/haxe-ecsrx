package systemsrx.infrastructure.modules;

import systemsrx.infrastructure.dependencies.IDependencyRegistry;
import systemsrx.infrastructure.dependencies.IDependencyModule;

// Импорты для конкретных реализаций (пока заглушки)
// import systemsrx.events.EventSystem;
// import systemsrx.executor.SystemExecutor;
// import systemsrx.executor.handlers.conventional.ManualSystemHandler;
class FrameworkModule implements IDependencyModule {
	public function new() {}

	public function setup(registry:IDependencyRegistry):Void {
		// Регистрация базовых компонентов фреймворка
		// registry.bind(IEventSystem, EventSystem);
		// registry.bind(ISystemExecutor, SystemExecutor);
		// registry.bind(IConventionalSystemHandler, ManualSystemHandler);
		// TODO: Добавить другие базовые обработчики систем
	}
}