package ecsrx.concurrent;

import ecsrx.systems.AbstractManualSystem;
import com.uking.concurrent.ThreadPool;
import com.uking.concurrent.Future;
import com.uking.concurrent.Promise;

class ConcurrentSystem extends AbstractManualSystem {
	private var _threadPool:ThreadPool;
	private var _activeTasks:Array<Future<Dynamic>> = [];

	public function new(?name:String, ?priority:Int, maxThreads:Int = 4) {
		super(name, priority);
		this._threadPool = new ThreadPool(maxThreads);
	}

	override public function update(elapsedTime:Float):Void {
		// Проверяем завершенные задачи
		checkCompletedTasks();
	}

	protected
	function runAsync<T>(task:Void->T):Future<T> {
		var promise = new Promise<T>();
		var future = promise.future;
		_threadPool.submit(function() {
			try {
				var result = task();
				promise.complete(result);
			} catch (e:Dynamic) {
				promise.error(e);
			}
		});
		_activeTasks.push(future);
		return future;
	}

	private function checkCompletedTasks():Void {
		var completedTasks = [];
		for (i in 0..._activeTasks.length) {
			var task = _activeTasks[i];
			if (task.isCompleted || task.isError) {
				completedTasks.push(i);
			}
		}
		// Удаляем завершенные задачи в обратном порядке
		completedTasks.reverse();
		for (index in completedTasks) {
			_activeTasks.splice(index, 1);
		}
	}

	override public function stopSystem():Void {
		// Отменяем все активные задачи
		for (task in _activeTasks) {
			// task.cancel(); // если поддерживается
		}
		_activeTasks = [];
		// Завершаем работу пула потоков
		_threadPool.shutdown();
		super.stopSystem();
	}
}