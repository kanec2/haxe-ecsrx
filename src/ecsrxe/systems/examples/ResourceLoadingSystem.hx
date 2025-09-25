package ecsrx.systems.examples;

import ecsrx.concurrent.ConcurrentSystem;
import com.uking.concurrent.Future;
import haxe.io.Bytes;

class ResourceLoadingSystem extends ConcurrentSystem {
	private var _pendingLoads:Map<String, Future<Bytes>> = new Map();

	public function new() {
		super("ResourceLoadingSystem", 50);
	}

	public function loadResourceAsync(path:String):Future<Bytes> {
		if (_pendingLoads.exists(path)) {
			return _pendingLoads.get(path);
		}
		var future = runAsync(function():Bytes {
			// Симуляция загрузки ресурса
			// В реальности здесь будет код загрузки файла
			return loadResourceFromFile(path);
		});
		_pendingLoads.set(path, future);
		return future;
	}

	private function loadResourceFromFile(path:String):Bytes {
		// Реальная реализация загрузки файла
		// Например, через sys.io.File или hxd.Res return null;
	}

	override public function update(elapsedTime:Float):Void {
		super.update(elapsedTime);
		// Проверяем завершенные загрузки
		var completed = [];
		for (path => future in _pendingLoads) {
			if (future.isCompleted) {
				try {
					var resource = future.result;
					onResourceLoaded(path, resource);
					completed.push(path);
				} catch (e:Dynamic) {
					onError(path, e);
					completed.push(path);
				}
			} else if (future.isError) {
				onError(path, future.error);
				completed.push(path);
			}
		}
		// Удаляем завершенные загрузки
		for (path in completed) {
			_pendingLoads.remove(path);
		}
	}

	private function onResourceLoaded(path:String, resource:Bytes):Void {
		trace('Resource loaded: $path');
		// Обработка загруженного ресурса
	}

	private function onError(path:String, error:Dynamic):Void {
		trace('Error loading resource $path: $error');
	}
}