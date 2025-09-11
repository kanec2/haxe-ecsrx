package tests.systemsrx.handlers;

import utest.Assert;
import utest.Test;
import systemsrx.executor.handlers.ManualSystemHandler;
import systemsrx.systems.conventional.IManualSystem;
import systemsrx.systems.ISystem;

/** 
 * Tests for ManualSystemHandler, adapted from SystemsRx.Tests.SystemsRx.Handlers.ManualSystemHandlerTests 
 */
class ManualSystemHandlerTest extends Test {
	// Фиктивные реализации
	class FakeManualSystem implements IManualSystem {
		public var startSystemCalled:Bool = false;
		public var stopSystemCalled:Bool = false;

		public function new() {}

		public function startSystem():Void {
			startSystemCalled = true;
		}

		public function stopSystem():Void {
			stopSystemCalled = true;
		}
	}
	class FakeNonManualSystem implements ISystem {
		public function new() {}
	}
	public function test_should_correctly_handle_systems() {
		var handler = new ManualSystemHandler();

		var fakeMatchingSystem = new FakeManualSystem();
		var fakeNonMatchingSystem1 = new FakeNonManualSystem();
		// ISystem это базовый интерфейс, поэтому создадим другой фиктивный класс
		var fakeNonMatchingSystem2 = new FakeNonManualSystem();

		Assert.isTrue(handler.canHandleSystem(fakeMatchingSystem));
		Assert.isFalse(handler.canHandleSystem(fakeNonMatchingSystem1));
		Assert.isFalse(handler.canHandleSystem(fakeNonMatchingSystem2));
	}

	public function test_should_start_system_when_added_to_handler() {
		var mockSystem = new FakeManualSystem();
		var systemHandler = new ManualSystemHandler();
		systemHandler.setupSystem(mockSystem);

		Assert.isTrue(mockSystem.startSystemCalled);
	}

	public function test_should_stop_system_when_added_to_handler() {
		var mockSystem = new FakeManualSystem();
		var systemHandler = new ManualSystemHandler();
		systemHandler.destroySystem(mockSystem);

		Assert.isTrue(mockSystem.stopSystemCalled);
	}
}