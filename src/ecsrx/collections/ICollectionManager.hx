package ecsrx.collections;

import ecsrx.entities.Entity;

interface ICollectionManager {
	function createCollection(?predicate:Entity->Bool, ?name:String):ICollection;
	function getCollection(?predicate:Entity->Bool, ?name:String):ICollection;
	function removeCollection(collection:ICollection):Void;
	function dispose():Void;
}