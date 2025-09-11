package systemsrx.events.process;

#if (threads || sys) // Предполагаем, что Future доступен из haxe-concurrent
import hx.concurrent.Future; #end /** * The IAsyncProcess represents a long term request/response style process using events. * * This is mainly used for when you want to send an event but require a response/notification * of the event being handled and completed. * For example you may need to tell a view component to move, which may take a few seconds * to happen, so with this interface you can start the process, then wait for the response * before doing something else. */ 
interface IAsyncProcess<T> {/** * Executes the asynchronous process. * @param eventSystem The event system to use for communication. * @return A Future representing the result of the process. */ #if (threads

	|| sys)
	function execute(eventSystem:IEventSystem):Future<T>;
#else
	// На платформах без потоков возвращаем Dynamic или заглушку
	function execute(eventSystem:IEventSystem):Dynamic;
#end
}