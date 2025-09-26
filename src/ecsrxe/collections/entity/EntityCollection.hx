package ecsrxe.collections.entity;

#if (threads || sys)
import rx.Observable;
import rx.Subject;
import rx.disposables.ISubscription;
import rx.disposables.CompositeDisposable;
import hx.concurrent.lock.Semaphore;
#end
import ecsrxe.entities.IEntity;
import ecsrxe.entities.IEntityFactory;
import ecsrxe.blueprints.IBlueprint;
import ecsrxe.collections.events.CollectionEntityEvent;
import ecsrxe.collections.events.ComponentsChangedEvent;
import ecsrxe.collections.entity.IEntityCollection;
import systemsrx.factories.IFactory;

// import systemsrx.extensions.IDisposable;

/** 
 * Entity collection implementation. 
 * This code is adapted from EcsRx.Collections.Entity.EntityCollection. 
 */
@:keep
class EntityCollection implements IEntityCollection /*implements IDisposable*/ {
	#if (threads || sys)
	public var id(default, null):Int;
	public var entityFactory(default, null):IEntityFactory;

	public final entityLookup:Map<Int, IEntity>;
	public final entitySubscriptions:Map<Int, CompositeDisposable>;

	public var entityAdded(get, null):Observable<CollectionEntityEvent>;
	public var entityRemoved(get, null):Observable<CollectionEntityEvent>;
	public var entityComponentsAdded(get, null):Observable<ComponentsChangedEvent>;
	public var entityComponentsRemoving(get, null):Observable<ComponentsChangedEvent>;
	public var entityComponentsRemoved(get, null):Observable<ComponentsChangedEvent>;

	final onEntityAdded:Subject<CollectionEntityEvent>;
	final onEntityRemoved:Subject<CollectionEntityEvent>;
	final onEntityComponentsAdded:Subject<ComponentsChangedEvent>;
	final onEntityComponentsRemoving:Subject<ComponentsChangedEvent>;
	final onEntityComponentsRemoved:Subject<ComponentsChangedEvent>;

	final lock:Semaphore; // Используем Semaphore как Mutex

	#end
	public function new(id:Int, entityFactory:IEntityFactory) {
		#if (threads || sys)
		this.entityLookup = new Map<Int, IEntity>();
		this.entitySubscriptions = new Map<Int, CompositeDisposable>();
		this.id = id;
		this.entityFactory = entityFactory;

		this.onEntityAdded = new rx.Subject<CollectionEntityEvent>(); // Subject.create<CollectionEntityEvent>()
		this.onEntityRemoved = new rx.Subject<CollectionEntityEvent>(); // Subject.create<CollectionEntityEvent>()
		this.onEntityComponentsAdded = new rx.Subject<ComponentsChangedEvent>(); // Subject.create<ComponentsChangedEvent>()
		this.onEntityComponentsRemoving = new rx.Subject<ComponentsChangedEvent>(); // Subject.create<ComponentsChangedEvent>()
		this.onEntityComponentsRemoved = new rx.Subject<ComponentsChangedEvent>(); // Subject.create<ComponentsChangedEvent>()

		// ИСПРАВЛЕНИЕ: Используем правильный конструктор Semaphore
		this.lock = new Semaphore(1); // Бинарный семафор для взаимного исключения (Mutex)
		#end
	}

	function get_entityAdded():Observable<CollectionEntityEvent> {
		#if (threads || sys)
		return onEntityAdded;
		#else
		return null;
		#end
	}

	function get_entityRemoved():Observable<CollectionEntityEvent> {
		#if (threads || sys)
		return onEntityRemoved;
		#else
		return null;
		#end
	}

	function get_entityComponentsAdded():Observable<ComponentsChangedEvent> {
		#if (threads || sys)
		return onEntityComponentsAdded;
		#else
		return null;
		#end
	}

	function get_entityComponentsRemoving():Observable<ComponentsChangedEvent> {
		#if (threads || sys)
		return onEntityComponentsRemoving;
		#else
		return null;
		#end
	}

	function get_entityComponentsRemoved():Observable<ComponentsChangedEvent> {
		#if (threads || sys)
		return onEntityComponentsRemoved;
		#else
		return null;
		#end
	}

	public function subscribeToEntity(entity:IEntity):Void {
		#if (threads || sys)
		lock.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;

		try {
			var entityDisposable = new CompositeDisposable();
			// Подписываемся на события компонентов сущности и перенаправляем их в свои Subject'ы
			// entity.ComponentsAdded.Subscribe(x => _onEntityComponentsAdded.OnNext(new ComponentsChangedEvent(entity, x))).AddTo(entityDisposable);
			// В Haxe это будет:
			var componentsAddedSubscription:ISubscription = entity.componentsAdded.subscribe(Observer.create( // onCompleted
				function():Void {
					// В данном случае ничего не делаем при завершении источника
				}, // onError
				function(error:String):Void {
					// Обрабатываем ошибку источника, если необходимо.
					// Для простоты, можно логировать или игнорировать.
					#if debug
					trace("Error in EntityCollection entity.ComponentsAdded observable: " + error);
					#end
				}, // onNext
				function(x:Array<Int>):Void { // Предполагаем, что ComponentsAdded возвращает Array<Int>
					onEntityComponentsAdded.on_next(new ComponentsChangedEvent(entity, x));
				}));
			entityDisposable.add(componentsAddedSubscription);

			// entity.ComponentsRemoving.Subscribe(x => _onEntityComponentsRemoving.OnNext(new ComponentsChangedEvent(entity, x))).AddTo(entityDisposable);
			// В Haxe это будет:
			var componentsRemovingSubscription:ISubscription = entity.componentsRemoving.subscribe(Observer.create( // onCompleted
				function():Void {
					// В данном случае ничего не делаем при завершении источника
				}, // onError
				function(error:String):Void {
					// Обрабатываем ошибку источника, если необходимо.
					// Для простоты, можно логировать или игнорировать.
					#if debug
					trace("Error in EntityCollection entity.ComponentsRemoving observable: " + error);
					#end
				}, // onNext
				function(x:Array<Int>):Void { // Предполагаем, что ComponentsRemoving возвращает Array<Int>
					onEntityComponentsRemoving.on_next(new ComponentsChangedEvent(entity, x));
				}));
			entityDisposable.add(componentsRemovingSubscription);

			// entity.ComponentsRemoved.Subscribe(x => _onEntityComponentsRemoved.OnNext(new ComponentsChangedEvent(entity, x))).AddTo(entityDisposable);
			// В Haxe это будет:
			var componentsRemovedSubscription:ISubscription = entity.componentsRemoved.subscribe(Observer.create( // onCompleted
				function():Void {
					// В данном случае ничего не делаем при завершении источника
				}, // onError
				function(error:String):Void {
					// Обрабатываем ошибку источника, если необходимо.
					// Для простоты, можно логировать или игнорировать.
					#if debug
					trace("Error in EntityCollection entity.ComponentsRemoved observable: " + error);
					#end
				}, // onNext
				function(x:Array<Int>):Void { // Предполагаем, что ComponentsRemoved возвращает Array<Int>
					onEntityComponentsRemoved.on_next(new ComponentsChangedEvent(entity, x));
				}));
			entityDisposable.add(componentsRemovedSubscription);

			entitySubscriptions.set(entity.id, entityDisposable);
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		lock.release();
		#end

		// Если была ошибка во время подписки, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}
	}

	public function unsubscribeFromEntity(entityId:Int):Void {
		#if (threads || sys)
		lock.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;

		try {
			// EntitySubscriptions.RemoveAndDispose(entityId);
			// В Haxe это будет:
			if (entitySubscriptions.exists(entityId)) {
				var disposable = entitySubscriptions.get(entityId);
				if (disposable != null) {
					disposable.dispose();
				}
				entitySubscriptions.remove(entityId);
			}
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		lock.release();
		#end

		// Если была ошибка во время отписки, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}
	}

	public function createEntity(?blueprint:IBlueprint, ?id:Int):IEntity {
		#if (threads || sys)
		lock.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;
		var entity:IEntity = null;

		if (id != null && entityLookup.exists(id)) {
			#if (threads || sys)
			lock.release();
			#end
			throw "id already exists";
		}

		try {
			entity = entityFactory.create(id);

			entityLookup.set(entity.id, entity);
			subscribeToEntity(entity);
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		lock.release();
		#end

		// Если была ошибка во время создания, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}

		// _onEntityAdded.OnNext(new CollectionEntityEvent(entity));
		// В Haxe это будет:
		onEntityAdded.on_next(new CollectionEntityEvent(entity));

		// blueprint?.Apply(entity);
		// В Haxe это будет:
		if (blueprint != null) {
			blueprint.apply(entity);
		}

		return entity;

		return null;
	}

	public function getEntity(id:Int):IEntity {
		#if (threads || sys)
		lock.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;
		var entity:IEntity = null;

		try {
			// return EntityLookup[id];
			// В Haxe это будет:
			entity = entityLookup.get(id);
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		lock.release();
		#end

		// Если была ошибка во время получения, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}

		return entity;

		return null;
	}

	public function removeEntity(id:Int, disposeOnRemoval:Bool = true):Void {
		#if (threads || sys)
		lock.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;
		var entity:IEntity = null;

		try {
			entity = getEntity(id);
			// EntityLookup.Remove(id);
			// В Haxe это будет:
			entityLookup.remove(id);

			var entityId = entity.id;

			if (disposeOnRemoval) {
				// entity.Dispose();
				// В Haxe это будет:
				entity.dispose();
				// EntityFactory.Destroy(entityId);
				// В Haxe это будет:
				entityFactory.destroy(entityId);
			}

			unsubscribeFromEntity(entityId);
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		lock.release();
		#end

		// Если была ошибка во время удаления, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}

		// _onEntityRemoved.OnNext(new CollectionEntityEvent(entity));
		// В Haxe это будет:
		onEntityRemoved.on_next(new CollectionEntityEvent(entity));
	}

	public function addEntity(entity:IEntity):Void {
		#if (threads || sys)
		lock.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;

		try {
			// EntityLookup.Add(entity);
			// В Haxe это будет:
			entityLookup.set(entity.id, entity);
			subscribeToEntity(entity);
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		lock.release();
		#end

		// Если была ошибка во время добавления, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}

		// _onEntityAdded.OnNext(new CollectionEntityEvent(entity));
		// В Haxe это будет:
		onEntityAdded.on_next(new CollectionEntityEvent(entity));
	}

	public function containsEntity(id:Int):Bool {
		#if (threads || sys)
		lock.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;
		var result:Bool = false;

		try {
			// return EntityLookup.Contains(id);
			// В Haxe это будет:
			result = entityLookup.exists(id);
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		lock.release();
		#end

		// Если была ошибка во время проверки, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}

		return result;

		return false;
	}

	public function iterator():Iterator<IEntity> {
		#if (threads || sys)
		lock.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;
		var result:Iterator<IEntity> = null;

		try {
			// return EntityLookup.GetEnumerator();
			// В Haxe это будет:
			// Создаем итератор по значениям Map
			result = entityLookup.iterator();
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		lock.release();
		#end

		// Если была ошибка во время создания итератора, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}

		return result;

		return [].iterator();
	}

	public function dispose():Void {
		#if (threads || sys)
		lock.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;

		try {
			// _onEntityAdded.Dispose();
			// В Haxe это будет:
			onEntityAdded.on_completed();
			// _onEntityRemoved.Dispose();
			// В Haxe это будет:
			onEntityRemoved.on_completed();
			// _onEntityComponentsAdded.Dispose();
			// В Haxe это будет:
			onEntityComponentsAdded.on_completed();
			// _onEntityComponentsRemoving.Dispose();
			// В Haxe это будет:
			onEntityComponentsRemoving.on_completed();
			// _onEntityComponentsRemoved.Dispose();
			// В Haxe это будет:
			onEntityComponentsRemoved.on_completed();

			// EntityLookup.Clear();
			// В Haxe это будет:
			entityLookup.clear();
			// EntitySubscriptions.RemoveAndDisposeAll();
			// В Haxe это будет:
			for (disposable in entitySubscriptions) {
				if (disposable != null) {
					disposable.dispose();
				}
			}
			entitySubscriptions.clear();
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		lock.release();
		#end

		// Если была ошибка во время освобождения, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}
	}

	public var count(get, null):Int;

	function get_count():Int {
		#if (threads || sys)
		lock.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;
		var result:Int = 0;

		try {
			// return EntityLookup.Count;
			// В Haxe это будет:
			result = entityLookup.count();
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		lock.release();
		#end

		// Если была ошибка во время получения количества, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}

		return result;

		return 0;
	}

	public function get(index:Int):IEntity {
		#if (threads || sys)
		lock.acquire();
		#end

		// Копируем логику try-finally вручную
		var hasError = false;
		var errorValue:Dynamic = null;
		var result:IEntity = null;

		try {
			// return EntityLookup.GetByIndex(index);
			// В Haxe это будет:
			// Map не поддерживает прямой доступ по индексу, нужно итерироваться
			var i = 0;
			for (entity in entityLookup) {
				if (i == index) {
					result = entity;
					break;
				}
				i++;
			}
			if (result == null) {
				throw "Index out of bounds";
			}
		} catch (e:Dynamic) {
			// Сохраняем информацию об ошибке
			hasError = true;
			errorValue = e;
		}

		#if (threads || sys)
		lock.release();
		#end

		// Если была ошибка во время получения по индексу, пробрасываем её после освобождения ресурсов
		if (hasError) {
			throw errorValue;
		}

		return result;

		return null;
	}
}