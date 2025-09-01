package ecsrx.entities;

import rx.Subject;
import rx.Observable;

class EntityDatabase implements IEntityDatabase {
	private var _entities:Map<Int, Entity> = new Map();
	private var _nextId:Int = 1;
	private var _entityAddedSubject:Subject<Entity>;
	private var _entityRemovedSubject:Subject<Entity>;
	private var _entityUpdatedSubject:Subject<Entity>;

	public function new() {
		_entityAddedSubject = Subject.create();
		_entityRemovedSubject = Subject.create();
		_entityUpdatedSubject = Subject.create();
	}

	public function createEntity(?name:String):Entity {
		var entity = new Entity(_nextId++, name);
		_entities.set(entity.id, entity);
		_entityAddedSubject.on_next(entity);
		return entity;
	}

	public function destroyEntity(entity:Entity):Void {
		_entities.remove(entity.id);
		_entityRemovedSubject.on_next(entity);
	}

	public function getEntity(id:Int):Entity {
		return _entities.get(id);
	}

	public function getEntities():Array<Entity> {
		return [for (entity in _entities) entity];
	}

	public function entityAdded():Observable<Entity> {
		return _entityAddedSubject;
	}

	public function entityRemoved():Observable<Entity> {
		return _entityRemovedSubject;
	}

	public function entityUpdated():Observable<Entity> {
		return _entityUpdatedSubject;
	}

	public function dispose():Void {
		_entityAddedSubject.on_completed();
		_entityRemovedSubject.on_completed();
		_entityUpdatedSubject.on_completed();
	}
}