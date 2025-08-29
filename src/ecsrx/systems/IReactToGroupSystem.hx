package ecsrx.systems;

import ecs.Collection;
import rx.Observable;

interface IReactToGroupSystem extends ISystem {
	function reactToGroup():Observable<Collection>;
    function process(collection:ICollection):Void;
}