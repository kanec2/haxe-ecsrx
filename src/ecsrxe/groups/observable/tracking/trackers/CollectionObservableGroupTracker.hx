
package ecsrxe.groups.observable.tracking.trackers; 
 
#if (threads || sys) 
import rx.Observable; 
import rx.Subject; 
import rx.disposables.ISubscription; 
import rx.disposables.CompositeDisposable; 
import hx.concurrent.lock.Semaphore; // Для синхронизации 
#end 
import ecsrxe.collections.entity.INotifyingCollection; 
import ecsrxe.entities.IEntity; 
import ecsrxe.groups.observable.tracking.trackers.ObservableGroupTracker; 
import ecsrxe.groups.observable.tracking.trackers.ICollectionObservableGroupTracker; 
import ecsrxe.groups.observable.tracking.events.EntityGroupStateChanged; 
import ecsrxe.groups.observable.tracking.types.GroupMatchingType; 
import ecsrxe.groups.observable.tracking.types.GroupActionType; 
import ecsrxe.groups.LookupGroup; 
import systemsrx.extensions.IDisposable; 
import systemsrx.extensions.IEnumerableExtensions; 
 
/** 
 * Tracker for observable group matching changes for a collection of entities. 
 * Extends ObservableGroupTracker to provide collection-specific tracking logic. 
 */ 
@:keep // Чтобы класс не был удален DCE 
class CollectionObservableGroupTracker extends ObservableGroupTracker implements ICollectionObservableGroupTracker { 
 #if (threads || sys) 
 final _notifyingSubs:CompositeDisposable; 
 public var entityIdMatchTypes:Map<Int, GroupMatchingType>; 
 var notifyingEntityComponentChanges:Iterable<INotifyingCollection>; 
 final _lock:Semaphore; // Используем Semaphore как Mutex 
 #end 
 
 public function new(lookupGroup:LookupGroup, initialEntities:Iterable<IEntity>, notifyingEntityComponentChanges:Iterable<INotifyingCollection>) { 
 #if (threads || sys) 
 // Вызываем конструктор родителя 
 super(lookupGroup); 
 
 this.notifyingEntityComponentChanges = notifyingEntityComponentChanges; 
 this._notifyingSubs = new CompositeDisposable(); 
 
 // Бинарный семафор для взаимного исключения (Mutex) 
 this._lock = new Semaphore(1); 
 
 // Инициализируем EntityIdMatchTypes из initialEntities 
 // В C# было: initialEntities.ToDictionary(x => x.Id, x => LookupGroup.CalculateMatchingType(x)); 
 this.entityIdMatchTypes = new Map<Int, GroupMatchingType>(); 
 if (initialEntities != null) { 
 for (entity in initialEntities) { 
 if (entity != null) { 
 var entityId = entity.id; 
 var matchType = lookupGroup.calculateMatchingType(entity); 
 entityIdMatchTypes.set(entityId, matchType); 
 } 
 } 
 } 
 
 // Подписываемся на изменения сущностей в каждой коллекции 
 // В C# было: NotifyingEntityComponentChanges.ForEachRun(MonitorEntityChanges); 
 if (notifyingEntityComponentChanges != null) { 
 for (notifier in notifyingEntityComponentChanges) { 
 if (notifier != null) { 
 monitorEntityChanges(notifier); 
 } 
 } 
 } 
 #end 
 } 
 
 /** 
 * Monitors entity changes in a notifying collection. 
 * @param notifier The notifying collection to monitor. 
 */ 
 public function monitorEntityChanges(notifier:INotifyingCollection):Void { 
 #if (threads || sys) 
 _lock.acquire(); 
 #end 
 
 // Копируем логику try-finally вручную 
 var hasError = false; 
 var errorValue:Dynamic = null; 
 
 try { 
 // Подписываемся на события добавления и удаления сущностей 
 // В C# было: notifier.EntityAdded.Subscribe(OnEntityAdded).AddTo(_notifyingSubs); 
 var entityAddedSubscription:ISubscription = notifier.entityAdded.subscribe(Observer.create( 
 // onCompleted 
 function():Void { 
 // В данном случае ничего не делаем при завершении источника 
 }, 
 // onError 
 function(error:String):Void { 
 // Обрабатываем ошибку источника, если необходимо. 
 #if debug 
 trace("Error in CollectionObservableGroupTracker notifier.EntityAdded observable: " + error); 
 #end 
 }, 
 // onNext 
 function(args:CollectionEntityEvent):Void { 
 onEntityAdded(args); 
 } 
 )); 
 _notifyingSubs.add(entityAddedSubscription); 
 
 // В C# было: notifier.EntityRemoved.Subscribe(OnEntityRemoved).AddTo(_notifyingSubs); 
 var entityRemovedSubscription:ISubscription = notifier.entityRemoved.subscribe(Observer.create( 
 // onCompleted 
 function():Void { 
 // В данном случае ничего не делаем при завершении источника 
 }, 
 // onError 
 function(error:String):Void { 
 // Обрабатываем ошибку источника, если необходимо. 
 #if debug 
 trace("Error in CollectionObservableGroupTracker notifier.EntityRemoved observable: " + error); 
 #end 
 }, 
 // onNext 
 function(args:CollectionEntityEvent):Void { 
 onEntityRemoved(args); 
 } 
 )); 
 _notifyingSubs.add(entityRemovedSubscription); 
 
 // Подписываемся на события добавления компонентов 
 // В C# было: notifier.EntityComponentsAdded.Subscribe(x => OnEntityComponentAdded(x.ComponentTypeIds, x.Entity)).AddTo(_notifyingSubs); 
 var entityComponentsAddedSubscription:ISubscription = notifier.entityComponentsAdded.subscribe(Observer.create( 
 // onCompleted 
 function():Void { 
 // В данном случае ничего не делаем при завершении источника 
 }, 
 // onError 
 function(error:String):Void { 
 // Обрабатываем ошибку источника, если необходимо. 
 #if debug 
 trace("Error in CollectionObservableGroupTracker notifier.EntityComponentsAdded observable: " + error); 
 #end 
 }, 
 // onNext 
 function(args:ComponentsChangedEvent):Void { 
 onEntityComponentAdded(args.componentTypeIds, args.entity); 
 } 
 )); 
 _notifyingSubs.add(entityComponentsAddedSubscription); 
 
 // Подписываемся на события удаления компонентов (перед удалением) 
 // В C# было: notifier.EntityComponentsRemoving.Subscribe(x => OnEntityComponentRemoving(x.ComponentTypeIds, x.Entity)).AddTo(_notifyingSubs); 
 var entityComponentsRemovingSubscription:ISubscription = notifier.entityComponentsRemoving.subscribe(Observer.create( 
 // onCompleted 
 function():Void { 
 // В данном случае ничего не делаем при завершении источника 
 }, 
 // onError 
 function(error:String):Void { 
 // Обрабатываем ошибку источника, если необходимо. 
 #if debug 
 trace("Error in CollectionObservableGroupTracker notifier.EntityComponentsRemoving observable: " + error); 
 #end 
 }, 
 // onNext 
 function(args:ComponentsChangedEvent):Void { 
 onEntityComponentRemoving(args.componentTypeIds, args.entity); 
 } 
 )); 
 _notifyingSubs.add(entityComponentsRemovingSubscription); 
 
 // Подписываемся на события удаления компонентов (после удаления) 
 // В C# было: notifier.EntityComponentsRemoved.Subscribe(x => OnEntityComponentRemoved(x.ComponentTypeIds, x.Entity)).AddTo(_notifyingSubs); 
 var entityComponentsRemovedSubscription:ISubscription = notifier.entityComponentsRemoved.subscribe(Observer.create( 
 // onCompleted 
 function():Void { 
 // В данном случае ничего не делаем при завершении источника 
 }, 
 // onError 
 function(error:String):Void { 
 // Обрабатываем ошибку источника, если необходимо. 
 #if debug 
 trace("Error in CollectionObservableGroupTracker notifier.EntityComponentsRemoved observable: " + error); 
 #end 
 }, 
 // onNext 
 function(args:ComponentsChangedEvent):Void { 
 onEntityComponentRemoved(args.componentTypeIds, args.entity); 
 } 
 )); 
 _notifyingSubs.add(entityComponentsRemovedSubscription); 
 } catch (e:Dynamic) { 
 // Сохраняем информацию об ошибке 
 hasError = true; 
 errorValue = e; 
 } 
 
 #if (threads || sys) 
 _lock.release(); 
 #end 
 
 // Если была ошибка во время подписки, пробрасываем её после освобождения ресурсов 
 if (hasError) { 
 throw errorValue; 
 } 
 #end 
 } 
 
 /** 
 * Updates the state of an entity in the tracker. 
 * @param entityId The ID of the entity. 
 * @param newMatchingType The new matching type for the entity. 
 */ 
 public override function updateState(entityId:Int, newMatchingType:GroupMatchingType):Void { 
 #if (threads || sys) 
 _lock.acquire(); 
 #end 
 
 // Копируем логику try-finally вручную 
 var hasError = false; 
 var errorValue:Dynamic = null; 
 
 try { 
 entityIdMatchTypes.set(entityId, newMatchingType); 
 } catch (e:Dynamic) { 
 // Сохраняем информацию об ошибке 
 hasError = true; 
 errorValue = e; 
 } 
 
 #if (threads || sys) 
 _lock.release(); 
 #end 
 
 // Если была ошибка во время обновления состояния, пробрасываем её после освобождения ресурсов 
 if (hasError) { 
 throw errorValue; 
 } 
 #end 
 } 
 
 /** 
 * Gets the state of an entity in the tracker. 
 * @param entityId The ID of the entity. 
 * @return The matching type for the entity. 
 */ 
 public override function getState(entityId:Int):GroupMatchingType { 
 #if (threads || sys) 
 _lock.acquire(); 
 #end 
 
 // Копируем логику try-finally вручную 
 var hasError = false; 
 var errorValue:Dynamic = null; 
 var result:GroupMatchingType = GroupMatchingType.NoMatchesFound; 
 
 try { 
 // В C# было: return EntityIdMatchTypes.ContainsKey(entityId) ? EntityIdMatchTypes[entityId] : GroupMatchingType.NoMatchesFound; 
 if (entityIdMatchTypes.exists(entityId)) { 
 result = entityIdMatchTypes.get(entityId); 
 } else { 
 result = GroupMatchingType.NoMatchesFound; 
 } 
 } catch (e:Dynamic) { 
 // Сохраняем информацию об ошибке 
 hasError = true; 
 errorValue = e; 
 } 
 
 #if (threads || sys) 
 _lock.release(); 
 #end 
 
 // Если была ошибка во время получения состояния, пробрасываем её после освобождения ресурсов 
 if (hasError) { 
 throw errorValue; 
 } 
 
 return result; 
 #else 
 return GroupMatchingType.NoMatchesFound; // Заглушка для платформ без поддержки 
 #end 
 } 
 
 /** 
 * Checks if an entity is matching the group. 
 * @param entityId The ID of the entity. 
 * @return true if the entity is matching, false otherwise. 
 */ 
 public function isMatching(entityId:Int):Bool { 
 #if (threads || sys) 
 _lock.acquire(); 
 #end 
 
 // Копируем логику try-finally вручную 
 var hasError = false; 
 var errorValue:Dynamic = null; 
 var result:Bool = false; 
 
 try { 
 // В C# было: return EntityIdMatchTypes[entityId] == GroupMatchingType.MatchesNoExcludes; 
 // Но сначала нужно проверить, существует ли ключ 
 if (entityIdMatchTypes.exists(entityId)) { 
 result = entityIdMatchTypes.get(entityId) == GroupMatchingType.MatchesNoExcludes; 
 } else { 
 result = false; // Если ключ не существует, сущность не соответствует 
 } 
 } catch (e:Dynamic) { 
 // Сохраняем информацию об ошибке 
 hasError = true; 
 errorValue = e; 
 } 
 
 #if (threads || sys) 
 _lock.release(); 
 #end 
 
 // Если была ошибка во время проверки соответствия, пробрасываем её после освобождения ресурсов 
 if (hasError) { 
 throw errorValue; 
 } 
 
 return result; 
 #else 
 return false; // Заглушка для платформ без поддержки 
 #end 
 } 
 
 /** 
 * Handles the event when an entity is added to a collection. 
 * @param args The event arguments. 
 */ 
 public function onEntityAdded(args:CollectionEntityEvent):Void { 
 #if (threads || sys) 
 _lock.acquire(); 
 #end 
 
 // Копируем логику try-finally вручную 
 var hasError = false; 
 var errorValue:Dynamic = null; 
 var matchType:GroupMatchingType = GroupMatchingType.NoMatchesFound; 
 
 try { 
 if (args.entity == null) { 
 #if (threads || sys) 
 _lock.release(); 
 #end 
 return; // Ничего не делаем, если сущность null 
 } 
 
 var entityId = args.entity.id; 
 // В C# было: if (EntityIdMatchTypes.ContainsKey(args.Entity.Id)) { return; } 
 if (entityIdMatchTypes.exists(entityId)) { 
 #if (threads || sys) 
 _lock.release(); 
 #end 
 return; // Ничего не делаем, если сущность уже отслеживается 
 } 
 
 // В C# было: matchType = LookupGroup.CalculateMatchingType(args.Entity); 
 matchType = lookupGroup.calculateMatchingType(args.entity); 
 // В C# было: EntityIdMatchTypes.Add(args.Entity.Id, matchType); 
 entityIdMatchTypes.set(entityId, matchType); 
 } catch (e:Dynamic) { 
 // Сохраняем информацию об ошибке 
 hasError = true; 
 errorValue = e; 
 } 
 
 #if (threads || sys) 
 _lock.release(); 
 #end 
 
 // Если была ошибка во время обработки добавления сущности, пробрасываем её после освобождения ресурсов 
 if (hasError) { 
 throw errorValue; 
 } 
 
 // После освобождения блокировки проверяем matchType и уведомляем подписчиков 
 if (matchType == GroupMatchingType.MatchesNoExcludes) { 
 // В C# было: OnGroupMatchingChanged.OnNext(new EntityGroupStateChanged(args.Entity, GroupActionType.JoinedGroup)); 
 onGroupMatchingChanged.on_next(new EntityGroupStateChanged(args.entity, GroupActionType.JoinedGroup)); 
 } 
 } 
 
 /** 
 * Handles the event when an entity is removed from a collection. 
 * @param args The event arguments. 
 */ 
 public function onEntityRemoved(args:CollectionEntityEvent):Void { 
 #if (threads || sys) 
 _lock.acquire(); 
 #end 
 
 // Копируем логику try-finally вручную 
 var hasError = false; 
 var errorValue:Dynamic = null; 
 var matchType:GroupMatchingType = GroupMatchingType.NoMatchesFound; 
 
 try { 
 if (args.entity == null) { 
 #if (threads || sys) 
 _lock.release(); 
 #end 
 return; // Ничего не делаем, если сущность null 
 } 
 
 var entityId = args.entity.id; 
 // В C# было: if (!EntityIdMatchTypes.ContainsKey(args.Entity.Id)) { return; } 
 if (!entityIdMatchTypes.exists(entityId)) { 
 #if (threads || sys) 
 _lock.release(); 
 #end 
 return; // Ничего не делаем, если сущность не отслеживается 
 } 
 
 // В C# было: matchType = GetState(args.Entity.Id); 
 matchType = getState(entityId); 
 // В C# было: EntityIdMatchTypes.Remove(args.Entity.Id); 
 entityIdMatchTypes.remove(entityId); 
 } catch (e:Dynamic) { 
 // Сохраняем информацию об ошибке 
 hasError = true; 
 errorValue = e; 
 } 
 
 #if (threads || sys) 
 _lock.release(); 
 #end 
 
 // Если была ошибка во время обработки удаления сущности, пробрасываем её после освобождения ресурсов 
 if (hasError) { 
 throw errorValue; 
 } 
 
 // После освобождения блокировки проверяем matchType и уведомляем подписчиков 
 if (matchType == GroupMatchingType.MatchesNoExcludes) { 
 // В C# было: 
 // OnGroupMatchingChanged.OnNext(new EntityGroupStateChanged(args.Entity, GroupActionType.LeavingGroup)); 
 // OnGroupMatchingChanged.OnNext(new EntityGroupStateChanged(args.Entity, GroupActionType.LeftGroup)); 
 onGroupMatchingChanged.on_next(new EntityGroupStateChanged(args.entity, GroupActionType.LeavingGroup)); 
 onGroupMatchingChanged.on_next(new EntityGroupStateChanged(args.entity, GroupActionType.LeftGroup)); 
 } 
 } 
 
 /** 
 * Disposes of all resources used by the tracker. 
 */ 
 public override function dispose():Void { 
 #if (threads || sys) 
 _lock.acquire(); 
 #end 
 
 // Копируем логику try-finally вручную 
 var hasError = false; 
 var errorValue:Dynamic = null; 
 
 try { 
 // В C# было: OnGroupMatchingChanged?.Dispose(); 
 if (onGroupMatchingChanged != null) { 
 onGroupMatchingChanged.on_completed(); 
 // onGroupMatchingChanged.dispose(); // Subject может не иметь dispose() 
 } 
 // В C# было: _notifyingSubs.Dispose(); 
 _notifyingSubs.dispose(); 
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
 #end 
 } 
}