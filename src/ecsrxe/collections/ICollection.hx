package ecsrx.collections;

import ecsrx.entities.Entity;
import rx.Observable;

interface ICollection {
	var observable:Observable<Array<Entity>>;
	var entities:Array<Entity>;
	function containsEntity(entity:Entity):Bool;
	function count():Int;
	function dispose():Void;
}