package ecsrx.plugins;

import ecsrx.framework.IEcsRxApplication;

// import io.colyseus.Client; // когда будет доступна библиотека
class ColyseusPlugin implements IEcsRxPlugin {
	public var pluginName:String = "ColyseusPlugin";

	// private var _client:Client;
	private var _endpoint:String;

	public function new(endpoint:String = "ws://localhost:2567") {
		this._endpoint = endpoint;
	}

	public function beforeApplicationStarts(application:IEcsRxApplication):Void {
		/* // Создаем клиент Colyseus 
			_client = new Client(_endpoint); 
			// Регистрируем в DI 
			application.dependencyContainer.bind().to(_client).asSingleton(); 
		 */}

	public function afterApplicationStarts(application:IEcsRxApplication):Void {
		// Подключаемся к серверу
		// connectToServer();
	}

	/* 
		private function connectToServer():Void { 
			_client.joinOrCreate("game_room").then(function(room) { 
			trace("Connected to room: " + room.id); 
			// Настройка синхронизации 
			setupRoomSync(room); 
			}).catchError(function(error) { 
			trace("Connection error: " + error); 
			}); 
	}*/
	public function beforeApplicationStops(application:IEcsRxApplication):Void {
		// Отключаемся от сервера
		// if (_client != null) _client.close();
	}

	public function afterApplicationStops(application:IEcsRxApplication):Void {
		// Финальная очистка
	}
}