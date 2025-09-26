package ecsrxe.collections.database;

#if (threads || sys)
import rx.Observable;
import rx.Subject;
import rx.disposables.ISubscription;
import rx.disposables.CompositeDisposable;
import hx.concurrent.lock.Semaphore;
#end
import ecsrxe.collections.entity.INotifyingCollection;
import ecsrxe.collections.entity.IEntityCollection;
import ecsrxe.collections.entity.IEntityCollectionFactory;
import ecsrxe.entities.IEntity;
import ecsrxe.groups.IGroup;
import ecsrxe.collections.events.CollectionEntityEvent;
import ecsrxe.collections.events.ComponentsChangedEvent;
import ecsrxe.lookups.CollectionLookup;

/** 
 * Entity database implementation. 
 * This acts as the database to store all entities, rather than containing all entities directly 
 * within itself, it partitions them into collections which can contain differing amounts of entities. 
 */
@:keep
class EntityDatabase implements IEntityDatabase {
	#if (threads || sys)
	final _lock:Semaphore;
	#end

	final _collections:CollectionLookup;
	final _collectionSubscriptions:Map<Int, CompositeDisposable>;

	public var collections(get, null):Array<IEntityCollection>;
	public var entityCollectionFactory(default, null):IEntityCollectionFactory;

	public var entityAdded(get, null):Observable<CollectionEntityEvent>;
	public var entityRemoved(get, null):Observable<CollectionEntityEvent>;
	public var entityComponentsAdded(get, null):Observable<ComponentsChangedEvent>;
	public var entityComponentsRemoving(get, null):Observable<ComponentsChangedEvent>;
	public var entityComponentsRemoved(get, null):Observable<ComponentsChangedEvent>;
	public var collectionAdded(get, null):Observable<IEntityCollection>;
	public var collectionRemoved(get, null):Observable<IEntityCollection>;

	final _onEntityAdded:Subject<CollectionEntityEvent>;
	final _onEntityRemoved:Subject<CollectionEntityEvent>;
	final _onEntityComponentsAdded:Subject<ComponentsChangedEvent>;
	final _onEntityComponentsRemoving:Subject<ComponentsChangedEvent>;
	final _onEntityComponentsRemoved:Subject<ComponentsChangedEvent>;
	final _onCollectionAdded:Subject<IEntityCollection>;
	final _onCollectionRemoved:Subject<IEntityCollection>;

	public function new(entityCollectionFactory:IEntityCollectionFactory) {
		#if (threads || sys)
		// Бинарный семафор для взаимного исключения (Mutex)
		_lock = new Semaphore(1);
		#end

		this.entityCollectionFactory = entityCollectionFactory;

		_collections = new CollectionLookup();
		_collectionSubscriptions = new Map<Int, CompositeDisposable>();
		_onEntityAdded = new rx.Subject<CollectionEntityEvent>();
		_onEntityRemoved = new rx.Subject<CollectionEntityEvent>();
		_onEntityComponentsAdded = new rx.Subject<ComponentsChangedEvent>();
		_onEntityComponentsRemoving = new rx.Subject<ComponentsChangedEvent>();
		_onEntityComponentsRemoved = new rx.Subject<ComponentsChangedEvent>();
		_onCollectionAdded = new rx.Subject<IEntityCollection>();
		_onCollectionRemoved = new rx.Subject<IEntityCollection>();

		createCollection(EntityCollectionLookups.DefaultCollectionId);
	}

	function get_collections():Array<IEntityCollection> {
		#if (threads || sys)
		_lock.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;
		var result:Array<IEntityCollection> = [];

		try {
			result = _collections.toArray(); // Предполагаем метод toArray()
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		_lock.release();
		#end

		// Если была ошибка во время получения коллекций, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}

		return result;
	}

	function get_entityAdded():Observable<CollectionEntityEvent> {
		return _onEntityAdded;
	}

	function get_entityRemoved():Observable<CollectionEntityEvent> {
		return _onEntityRemoved;
	}

	function get_entityComponentsAdded():Observable<ComponentsChangedEvent> {
		return _onEntityComponentsAdded;
	}

	function get_entityComponentsRemoving():Observable<ComponentsChangedEvent> {
		return _onEntityComponentsRemoving;
	}

	function get_entityComponentsRemoved():Observable<ComponentsChangedEvent> {
		return _onEntityComponentsRemoved;
	}

	function get_collectionAdded():Observable<IEntityCollection> {
		return _onCollectionAdded;
	}

	function get_collectionRemoved():Observable<IEntityCollection> {
		return _onCollectionRemoved;
	}

	public function subscribeToCollection(collection:IEntityCollection):Void {
		#if (threads || sys)
		_lock.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;

		try {
			var collectionDisposable = new CompositeDisposable();
			collection.entityAdded.subscribe(Observer.create( // onCompleted
				function():Void {
					// В данном случае ничего не делаем при завершении источника
				}, // onError
				function(error:String):Void {
					// Обрабатываем ошибку источника, если необходимо.
					// Для простоты, можно логировать или игнорировать.
					#if debug
					trace("Error in EntityDatabase collection.EntityAdded observable: " + error);
					#end
				}, // onNext
				function(entityEvent:CollectionEntityEvent):Void {
					_onEntityAdded.on_next(entityEvent);
				})).add_to(collectionDisposable);

			collection.entityRemoved.subscribe(Observer.create( // onCompleted
				function():Void {
					// В данном случае ничего не делаем при завершении источника
				}, // onError
				function(error:String):Void {
					// Обрабатываем ошибку источника, если необходимо.
					// Для простоты, можно логировать или игнорировать.
					#if debug
					trace("Error in EntityDatabase collection.EntityRemoved observable: " + error);
					#end
				}, // onNext
				function(entityEvent:CollectionEntityEvent):Void {
					_onEntityRemoved.on_next(entityEvent);
				})).add_to(collectionDisposable);

			collection.entityComponentsAdded.subscribe(Observer.create( // onCompleted
				function():Void {
					// В данном случае ничего не делаем при завершении источника
				}, // onError
				function(error:String):Void {
					// Обрабатываем ошибку источника, если необходимо.
					// Для простоты, можно логировать или игнорировать.
					#if debug
					trace("Error in EntityDatabase collection.EntityComponentsAdded observable: " + error);
					#end
				}, // onNext
				function(componentsEvent:ComponentsChangedEvent):Void {
					_onEntityComponentsAdded.on_next(componentsEvent);
				})).add_to(collectionDisposable);

			collection.entityComponentsRemoving.subscribe(Observer.create( // onCompleted
				function():Void {
					// В данном случае ничего не делаем при завершении источника
				}, // onError
				function(error:String):Void {
					// Обрабатываем ошибку источника, если необходимо.
					// Для простоты, можно логировать или игнорировать.
					#if debug
					trace("Error in EntityDatabase collection.EntityComponentsRemoving observable: " + error);
					#end
				}, // onNext
				function(componentsEvent:ComponentsChangedEvent):Void {
					_onEntityComponentsRemoving.on_next(componentsEvent);
				})).add_to(collectionDisposable);

			collection.entityComponentsRemoved.subscribe(Observer.create( // onCompleted
				function():Void {
					// В данном случае ничего не делаем при завершении источника
				}, // onError
				function(error:String):Void {
					// Обрабатываем ошибку источника, если необходимо.
					// Для простоты, можно логировать или игнорировать.
					#if debug
					trace("Error in EntityDatabase collection.EntityComponentsRemoved observable: " + error);
					#end
				}, // onNext
				function(componentsEvent:ComponentsChangedEvent):Void {
					_onEntityComponentsRemoved.on_next(componentsEvent);
				})).add_to(collectionDisposable);

			_collectionSubscriptions.set(collection.id, collectionDisposable);
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		_lock.release();
		#end

		// Если была ошибка во время подписки на коллекцию, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}
	}

	public function unsubscribeFromCollection(id:Int):Void {
		#if (threads || sys)
		_lock.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;

		try {
			if (_collectionSubscriptions.exists(id)) {
				var subscription = _collectionSubscriptions.get(id);
				if (subscription != null) {
					subscription.dispose();
				}
				_collectionSubscriptions.remove(id);
			}
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		_lock.release();
		#end

		// Если была ошибка во время отписки от коллекции, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}
	}

	public function createCollection(id:Int):IEntityCollection {
		#if (threads || sys)
		_lock.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;
		var collection:IEntityCollection = null;

		try {
			collection = entityCollectionFactory.create(id);
			addCollection(collection);
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		_lock.release();
		#end

		// Если была ошибка во время создания коллекции, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}

		return collection;
	}

	public function addCollection(collection:IEntityCollection):Void {
		#if (threads || sys)
		_lock.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;

		try {
			_collections.add(collection);
			subscribeToCollection(collection);
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		_lock.release();
		#end

		// Если была ошибка во время добавления коллекции, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}

		_onCollectionAdded.on_next(collection);
	}

	public function getCollection(?id:Int = EntityCollectionLookups.DefaultCollectionId):IEntityCollection {
		#if (threads || sys)
		_lock.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;
		var collection:IEntityCollection = null;

		try {
			if (_collections.contains(id)) {
				collection = _collections.get(id);
			} else {
				collection = null; // Безопасный Get, возвращает null, если коллекция не найдена
			}
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		_lock.release();
		#end

		// Если была ошибка во время получения коллекции, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}

		return collection;
	}

	public function get(id:Int):IEntityCollection {
		#if (threads || sys)
		_lock.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;
		var collection:IEntityCollection = null;

		try {
			// Прямой доступ к коллекции, бросает исключение, если не существует
			collection = _collections.get(id); // Может бросить исключение, если не существует
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		_lock.release();
		#end

		// Если была ошибка во время прямого доступа к коллекции, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}

		return collection;
	}

	public function removeCollection(id:Int, disposeEntities:Bool = true):Void {
		#if (threads || sys)
		_lock.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;
		var removedCollection:IEntityCollection = null;

		try {
			if (!_collections.contains(id)) {
				#if (threads || sys)
				_lock.release();
				#end
				return; // Коллекция не существует, ничего не делаем
			}

			removedCollection = _collections.get(id);
			_collections.remove(id);

			unsubscribeFromCollection(id);
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		_lock.release();
		#end

		// Если была ошибка во время удаления коллекции, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}

		if (removedCollection != null) {
			_onCollectionRemoved.on_next(removedCollection);
		}
	}

	public function dispose():Void {
		#if (threads || sys)
		_lock.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;

		try {
			_onEntityAdded.on_completed();
			_onEntityRemoved.on_completed();
			_onEntityComponentsAdded.on_completed();
			_onEntityComponentsRemoving.on_completed();
			_onEntityComponentsRemoved.on_completed();
			_onCollectionAdded.on_completed();
			_onCollectionRemoved.on_completed();

			for (subscription in _collectionSubscriptions) {
				if (subscription != null) {
					subscription.dispose();
				}
			}
			_collectionSubscriptions.clear();

			_collections.clear();
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		_lock.release();
		#end

		// Если была ошибка во время освобождения ресурсов, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}
	}
}