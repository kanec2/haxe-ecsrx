package systemsrx.systems.conventional;

import systemsrx.systems.ISystem; 
/** * IReactToEventSystem are specifically made to act as event handlers, * so when the given event comes in the system processes the event. * @typeparam T The type of event to handle */ 
interface IReactToEventSystem<T> extends ISystem {

	function process(eventData:T):Void;
}