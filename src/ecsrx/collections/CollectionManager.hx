package ecsrx.collections;

import ecsrx.entities.Entity;
import ecsrx.entities.IEntityDatabase;
import haxe.ds.StringMap;
import rx.Subscription;
import rx.disposables.ISubscription; 
import rx.Observer;
class CollectionManager implements ICollectionManager {
	private var _collections:Array<Collection> = [];
	private var _namedCollections:StringMap<Collection> = new StringMap();
	private var _entityDatabase:IEntityDatabase;
	private var _subscriptions:Array<ISubscription> = [];

	public function new(entityDatabase:IEntityDatabase) {
		this._entityDatabase = entityDatabase;
		subscribeToEntityEvents();
	}

	private function subscribeToEntityEvents():Void {
		var addedSub = _entityDatabase.entityAdded().subscribe(Observer.create(onEntityAdded));
		var removedSub = _entityDatabase.entityRemoved().subscribe(Observer.create(onEntityRemoved));
		var updatedSub = _entityDatabase.entityUpdated().subscribe(Observer.create(onEntityUpdated));
		_subscriptions.push(addedSub);
		_subscriptions.push(removedSub);
		_subscriptions.push(updatedSub);
	}

	private function onEntityAdded(entity:Entity):Void {
		for (collection in _collections) {
			collection.addEntity(entity);
		}
	}

	private function onEntityRemoved(entity:Entity):Void {
		for (collection in _collections) {
			collection.removeEntity(entity);
		}
	}

	private function onEntityUpdated(entity:Entity):Void {
		for (collection in _collections) {
			collection.updateEntity(entity);
		}
	}

	public function createCollection(?predicate:Entity->Bool, ?name:String):ICollection {
		var collection = new Collection(predicate);
		// Инициализируем коллекцию существующими сущностями
		var entities = _entityDatabase.getEntities();
		for (entity in entities) {
			collection.addEntity(entity);
		}
		_collections.push(collection);
		if (name != null) {
			_namedCollections.set(name, collection);
		}
		return collection;
	}

	public function getCollection(?predicate:Entity->Bool, ?name:String):ICollection {
		if (name != null && _namedCollections.exists(name)) {
			return _namedCollections.get(name);
		}
		// Ищем существующую коллекцию с таким же предикатом
		if (predicate != null) {
			for (collection in _collections) {
				// Здесь можно добавить сравнение предикатов
				// Пока просто возвращаем первую подходящую
			}
		}
		// Создаем новую, если не найдена
		return createCollection(predicate, name);
	}

	public function removeCollection(collection:ICollection):Void {
		var col:Collection = cast collection;
		_collections.remove(col);
		col.dispose();
		// Удаляем из именованных коллекций
		for (key in _namedCollections.keys()) {
			if (_namedCollections.get(key) == col) {
				_namedCollections.remove(key);
				break;
			}
		}
	}

	public function dispose():Void {
		for (subscription in _subscriptions) {
			subscription.unsubscribe();
		}
		_subscriptions = [];
		for (collection in _collections) {
			collection.dispose();
		}
		_collections = [];
		_namedCollections.clear();
	}
}