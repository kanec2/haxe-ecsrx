package tests.systemsrx.executor;

import utest.Assert;
import utest.Test;
import systemsrx.executor.SystemExecutor;
import systemsrx.systems.ISystem;
import systemsrx.executor.handlers.IConventionalSystemHandler;
import tests.systemsrx.executor.FakeSystem; import tests.systemsrx.executor.FakeSystemHandler;
// import systemsrx.exceptions.SystemAlreadyRegisteredException; // Если создан

/** 
 * Tests for SystemExecutor, adapted from SystemsRx.Tests.SystemsRx.Handlers.SystemExecutorTests 
 */
class SystemExecutorTest extends Test {
	
	
	public function test_should_handle_and_expose_system() {
		var fakeSystemHandler = new FakeSystemHandler(true);
		var fakeSystem = new FakeSystem();

		var systemExecutor = new SystemExecutor([fakeSystemHandler]);
		systemExecutor.addSystem(fakeSystem);

		Assert.isTrue(fakeSystemHandler.setupSystemCalled);
		Assert.equals(fakeSystem, fakeSystemHandler.systemPassedToSetup);
		Assert.isTrue(systemExecutor.systems.contains(fakeSystem));
	}

	public function test_should_handle_and_remove_system() {
		var fakeSystemHandler = new FakeSystemHandler(true);
		var fakeSystem = new FakeSystem();

		var systemExecutor = new SystemExecutor([fakeSystemHandler]);
		// Добавляем систему напрямую в список, как в C# тесте
		systemExecutor.systems.push(fakeSystem);

		systemExecutor.removeSystem(fakeSystem);

		Assert.isTrue(fakeSystemHandler.destroySystemCalled);
		Assert.equals(fakeSystem, fakeSystemHandler.systemPassedToDestroy);
		Assert.equals(0, systemExecutor.systems.length);
	}

	public function test_should_return_true_if_system_already_exists() {
		var fakeSystem = new FakeSystem();

		var systemExecutor = new SystemExecutor([]);
		systemExecutor.systems.push(fakeSystem);
		Assert.isTrue(systemExecutor.hasSystem(fakeSystem));
	}

	public function test_should_return_false_if_system_doesnt_exist() {
		var fakeSystem = new FakeSystem();

		var systemExecutor = new SystemExecutor([]);
		Assert.isFalse(systemExecutor.hasSystem(fakeSystem));
	}

	// Добавьте другие тесты по аналогии...
	// Обратите внимание, что тест на исключение требует, чтобы SystemExecutor
	// выбрасывал конкретный тип исключения, что в Haxe может быть проще реализовать
	// через обычные throw.
}