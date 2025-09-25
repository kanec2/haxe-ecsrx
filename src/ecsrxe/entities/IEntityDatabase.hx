package ecsrx.entities;

import rx.Observable;

interface IEntityDatabase {
	function createEntity(?name:String):Entity;
	function destroyEntity(entity:Entity):Void;
	function getEntity(id:Int):Entity;
	function getEntities():Array<Entity>;
	// Events
	function entityAdded():Observable<Entity>;
	function entityRemoved():Observable<Entity>;
	function entityUpdated():Observable<Entity>;

	function dispose():Void; // Добавлено
}