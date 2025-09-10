package systemsrx.pools; 
/** 
 * * Interface for a pool of integer IDs (starting from 1). 
 * * Extends the generic IPool interface for int. 
 * */ 
 interface IIdPool extends IPool<Int> {
    /** 
     * * Checks if a specific ID is available in the pool. 
     * * @param id The ID to check. 
     * * @return True if the ID is available, false otherwise. 
     * */ 
    function isAvailable(id:Int):Bool; 
    /** 
     * * Allocates a specific ID, removing it from the pool if it was available 
     * * or expanding the pool to accommodate it. 
     * * @param id The specific ID to allocate. 
     * */ 
    function allocateSpecificId(id:Int):Void;

}