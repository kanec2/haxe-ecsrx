package systemsrx.threading;
#if (threads || sys) import hx.concurrent.Future; #end
/** * Interface for handling threading operations in a cross-platform way. */
interface IThreadHandler {
	/** * Executes a parallel for loop from start (inclusive) to end (exclusive). 
	 * * @param start The starting index (inclusive). 
	 * * @param end The ending index (exclusive). 
	 * * @param process The function to execute for each index. 
	**/
	function forLoop(start:Int, end:Int, process:Int->Void):Void;

    /** 
     * * Runs a given process asynchronously. 
	 * * @param process The function to run asynchronously. 
     * @return A Future representing the asynchronous operation.
	**/
    #if (threads || sys)
    function run(process:Void->Void):Future<Dynamic>; // Используем Future из haxe-concurrent
    #else
	// На платформах без потоков возвращаем CompletedFuture
    function run(process:Void->Void):hx.concurrent.Future<Dynamic>; // Или можно определить простой CompletedFutureStub
    #end
}