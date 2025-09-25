package ecsrx.collections;

import ecsrx.entities.Entity;
import rx.Observable;
import rx.subjects.Behavior;

class Collection implements ICollection {
	public var observable:Observable<Array<Entity>>;
	public var entities:Array<Entity>;

	private var _subject:Behavior<Array<Entity>>;
	private var _predicate:Entity->Bool;
	private var _name:String;


	public function new(?predicate:Entity->Bool, ?name:String) {
		this._predicate = predicate != null ? predicate : (e) -> true;
		this._name = name;
		this.entities = [];
		this._subject = new Behavior([]);
		this.observable = _subject;
	}

	public function containsEntity(entity:Entity):Bool {
		return entities.contains(entity);
	}

	public function count():Int {
		return entities.length;
	}

	public function getName():String {
		return _name;
	}

	// Методы для управления составом коллекции
	public function addEntity(entity:Entity):Void {
		if (!entities.contains(entity) && _predicate(entity)) {
			entities.push(entity);
			notifyChange();
		}
	}

	public function removeEntity(entity:Entity):Void {
		if (entities.remove(entity)) {
			notifyChange();
		}
	}

	private function notifyChange():Void { 
		_subject.onNext(entities.copy()); 
	}
	
	public function updateEntity(entity:Entity):Void {
		var contains = entities.contains(entity);
		var matches = _predicate(entity);
		
		if (matches && !contains) {
			entities.push(entity);
			_subject.on_next(entities.copy());
		} else if (!matches && contains) {
			entities.remove(entity);
			_subject.on_next(entities.copy());
		}
	}

	public function dispose():Void {
		_subject.on_completed();
		entities = [];
	}
}