
import utest.Runner;
import utest.ui.Report;
import tests.systemsrx.*;
import tests.systemsrx.executor.*;
import tests.systemsrx.handlers.*;
import tests.systemsrx.pools.*;
import tests.systemsrx.sanity.*;
import tests.systemsrx.systems.*;
import tests.systemsrx.plugins.*;
import tests.systemsrx.plugins.reactivedata.*;
import tests.systemsrx.plugins.computeds.*;
import tests.systemsrx.extensions.*;
/** 
 * Main entry point for running all tests in the haxe-ecsrx project. 
 */
class TestSystemsRx {
	public static function main() {
		// Создаем раннер для тестов
		var runner = new Runner();

		// Добавляем все тестовые классы
		// Pools
		runner.addCase(new IndexPoolTest());
		runner.addCase(new IdPoolTest());

		// Executor
		runner.addCase(new SystemExecutorTest());

		// Handlers
		runner.addCase(new ManualSystemHandlerTest());
		// Добавьте другие тесты для обработчиков, когда они будут реализованы
		// runner.addCase(new systemsrx.handlers.BasicSystemHandlerTest());
		// runner.addCase(new systemsrx.handlers.ReactToEventSystemHandlerTest());
		// runner.addCase(new systemsrx.handlers.ReactiveSystemHandlerTest());

		// ReactiveData
		runner.addCase(new SanityTests());
		runner.addCase(new ReactivePropertyTests());

		// Computeds
		runner.addCase(new ComputedFromDataTests());

		// Extensions (ранее IDictionaryExtensionTests)
		//runner.addCase(new MapExtensionsTest());

		// Добавьте другие тестовые классы по мере их создания
		// Например:
		// runner.addCase(new systemsrx.systems.SystemPriorityTests());
		// runner.addCase(new systemsrx.events.EventSystemTests());
		// runner.addCase(new systemsrx.microrx.MessageBrokerTests());
		// runner.addCase(new systemsrx.reactivedata.collections.ReactiveCollectionTests());

		// Создаем отчет для вывода результатов в консоль
		Report.create(runner);

		// Запускаем тесты
		runner.run();
	}
}