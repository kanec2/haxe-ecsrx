package ecsrx.systems;

import ecsrx.entities.Entity;
import rx.Observable;

interface IReactToEntitySystem extends ISystem {
	function reactToEntity():Observable<Entity>;
    function process(entity:Entity):Void;
}