package tests.systemsrx.pools;

import utest.Assert;
import utest.Test;
import systemsrx.pools.IdPool;

class IdPoolAdditionalTests extends Test {
	public function test_should_handle_zero_increment_size() {
		var idPool = new IdPool(0, 10);
		// При incrementSize = 0 expand() не должен добавлять новых ID
		// Но allocateInstance() должен бросить исключение, когда пул пуст
		idPool.availableIds.resize(0); // Очищаем пул
		try {
			idPool.allocateInstance();
			Assert.fail("Should have thrown an exception");
		} catch (e:Dynamic) {
			// Ожидаем исключение
		}
	}

	public function test_should_handle_negative_release() {
		var idPool = new IdPool(10, 10);
		try {
			idPool.releaseInstance(-1);
			Assert.fail("Should have thrown an exception");
		} catch (e:Dynamic) {
			// Ожидаем исключение
		}
	}

	public function test_should_handle_double_dispose() {
		var idPool = new IdPool(10, 10);
		idPool.dispose();
		// Второй вызов dispose не должен бросать исключение
		idPool.dispose();
		Assert.isTrue(true); // Просто проверяем, что не было исключения
	}
}