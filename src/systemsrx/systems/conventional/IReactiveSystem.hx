package systemsrx.systems.conventional;

import systemsrx.systems.ISystem;
#if (concurrent || sys) import rx.Observable; #end /** * Reactive systems react to a stream of data. */ interface IReactiveSystem<T> extends ISystem {#if (threads

	|| sys) /** * Returns an observable indicating when the system should execute. * @return Observable indicating when the system should execute. */ function reactTo():Observable<T>; /** * The method to execute on triggering. */ function execute(data:T):Void; #end

}