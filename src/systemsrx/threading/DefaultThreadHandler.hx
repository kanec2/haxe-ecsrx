package systemsrx.threading; #if (threads || sys) import hx.concurrent.thread.Threads;

import hx.concurrent.lock.Semaphore;
import hx.concurrent.Future;
import hx.concurrent.Future.CompletableFuture; #end import hx.concurrent.Future.CompletedFuture;

/** 
 * * Default implementation of IThreadHandler using haxe-concurrent where possible. 
**/
class DefaultThreadHandler implements IThreadHandler {
	public function new() {
		// Инициализация, если требуется
	}

	public function forLoop(start:Int, end:Int, process:Int->Void):Void {
		#if (threads || sys)
		// Используем haxe-concurrent для параллельного выполнения
		var semaphore = new Semaphore(0);
		var tasksCount = end - start;
		// Создаем задачу для каждой итерации
		for (i in start...end) {
			var iterationIndex = i;
			Threads.spawn(() -> {
				process(iterationIndex);
				semaphore.release();
			});
		}
		// Ждем завершения всех задач
		for (i in 0...tasksCount) {
			semaphore.acquire();
		}
		#else
		// На однопоточных или не поддерживающих потоки платформах выполняем последовательно
		for (i in start...end) {
			process(i);
		}
		#end
	}

	#if (threads || sys)
	public function run(process:Void->Void):Future<Dynamic> {
		// Создаем CompletableFuture для отслеживания результата
		var future = new CompletableFuture<Dynamic>();
		Threads.spawn(() -> {
			try {
				process();
				// Отмечаем future как завершенный успешно
				future.complete(Either2.a(null)); // null как "значение" для Void операции
			} catch (e:Dynamic) {
				// Отмечаем future как завершенный с ошибкой
				var concurrentEx = new hx.concurrent.ConcurrentException("Task execution failed", e);
				future.complete(Either2.b(concurrentEx));
			}
		});
		return future;
	}
	#else
	public function run(process:Void->Void):hx.concurrent.Future<Dynamic> {
		// На однопоточных платформах
		#if js
		// Используем setTimeout(0) и возвращаем CompletedFuture
		haxe.Timer.delay(() -> {
			try {
				process();
			} catch (e:Dynamic) {
				// В однопоточном контексте просто пробрасываем исключение
				throw e;
			}
		}, 0);
		return new CompletedFuture(null);
		// Возвращаем уже завершенный Future
		#else
		// В других однопоточных средах выполняем синхронно и возвращаем CompletedFuture
		try {
			process();
			return new CompletedFuture(null); // null как "значение" для Void операции
		} catch (e:Dynamic) {
			var concurrentEx = new hx.concurrent.ConcurrentException("Task execution failed", e);
			var failedFuture = new hx.concurrent.Future.CompletableFuture<Dynamic>();
			failedFuture.complete(Either2.b(concurrentEx));
			return failedFuture;
		}
		#end
	}
	#end
}