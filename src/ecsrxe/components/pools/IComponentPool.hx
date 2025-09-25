package ecsrxe.components.pools;

#if (threads || sys)
import rx.Observable;
import rx.disposables.ISubscription;
#end
import ecsrxe.components.IComponent;
import ecsrxe.components.pools.IComponentPool;

/** 
 * Acts as a basic memory block for components of a specific type. 
 * This helps speed up access for components of the same type. 
 */
interface IComponentPool /*extends Iterable<Dynamic>*/ /*implements IDisposable*/ {
	/** 
	 * Amount of components within the pool. 
	 */
	var count(get, null):Int;

	/** 
	 * The amount of indexes remaining in this pool before a resize is needed. 
	 */
	var indexesRemaining(get, null):Int;

	/** 
	 * To notify when a pool has extended. 
	 */
	var onPoolExtending(get, null):Observable<Bool>;

	/** 
	 * Automatically expand the pool. 
	 */
	function expand():Void;

	/** 
	 * Manually expand the pool. 
	 * @param amountToAdd The amount of components to add to the pool. 
	 */
	function expand(amountToAdd:Int):Void;

	/** 
	 * Set a component to a specific index. 
	 * @param index The index to set. 
	 * @param value The component to use. 
	 */
	function set(index:Int, value:Dynamic):Void;

	/** 
	 * Allocates space for the pools and indexes. 
	 * @return The id of the allocation. 
	 */
	function allocate():Int;

	/** 
	 * Releases the component at the given index. 
	 * @param index The index of the component to release. 
	 */
	function release(index:Int):Void;

	/** 
	 * Disposes of all resources used by the component pool. 
	 */
	function dispose():Void;

	/** 
	 * Returns an iterator over the components in the pool. 
	 */
	function iterator():Iterator<Dynamic>;
}