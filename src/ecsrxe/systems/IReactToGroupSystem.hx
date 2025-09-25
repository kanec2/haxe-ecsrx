package ecsrx.systems;

import ecsrx.collections.ICollection; 
import rx.Observable;

interface IReactToGroupSystem extends ISystem {
	function reactToGroup():Observable<ICollection>;
    function process(collection:ICollection):Void;
}