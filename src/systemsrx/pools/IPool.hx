package systemsrx.pools; 
/** * Generic pool interface for allocating and releasing instances of type T. */ 
interface IPool<T> {
    /** * The size to expand the pool by if needed. */ 
    var incrementSize(get,null):Int; 
    /** * Allocates an instance in the pool for use. 
     * * @return An instance to use. 
     * */ 
    function allocateInstance():T; 
    /** * Frees up the pooled item for re-allocation. 
     * * @param obj The instance to put back in the pool. 
     * */ 
    function releaseInstance(obj:T):Void;

}