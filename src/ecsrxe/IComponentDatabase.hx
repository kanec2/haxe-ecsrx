package ecsrx;

import ecs.Entity;
import ecs.IComponent;

interface IComponentDatabase {
	function addComponent(entity:Entity, component:IComponent):Void;
	function removeComponent(entity:Entity, component:IComponent):Void;
	function getComponent<T:IComponent>(entity:Entity, componentType:Class<T>):T;
	function hasComponent<T:IComponent>(entity:Entity, componentType:Class<T>):Bool;
}