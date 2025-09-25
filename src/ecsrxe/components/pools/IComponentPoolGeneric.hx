package ecsrxe.components.pools;

#if (threads || sys)
import rx.Observable;
import rx.disposables.ISubscription;
#end
import ecsrxe.components.IComponent;
import ecsrxe.components.pools.IComponentPool;

/** 
 * Acts as a basic memory block for components of a specific type. 
 * This helps speed up access when you want components of the same type. 
 * @typeparam T Type of component. 
 */
interface IComponentPoolGeneric<T:IComponent> extends IComponentPool /*implements IDisposable*/ {
	/** 
	 * Contiguous block of memory for components. 
	 */
	var components(get, null):Array<T>;
}