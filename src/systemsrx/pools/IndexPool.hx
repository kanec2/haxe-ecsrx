package systemsrx.pools;

import hx.concurrent.lock.Semaphore;

/** 
 * Pool for managing integer indexes, starting from 0. 
 * Mimics the behavior of SystemsRx.IndexPool using a Stack-like approach with Haxe Array. 
 * Indexes are allocated in ascending order: 0, 1, 2, ... 
 */
class IndexPool implements IPool<Int> {
	#if (threads || sys)
	final semaphore:Semaphore;
	#end

	public var incrementSize(get, null):Int;
	public var availableIndexes:Array<Int>;

	public var lastMax:Int; // Keep public for tests

	final _incrementSize:Int;

	/** 
	 * Creates a new IndexPool. 
	 * @param increaseSize The amount to increase the pool size by when it's empty. Default is 100. 
	 * @param startingSize The initial size of the pool. Default is 1000. 
	 */
	public function new(increaseSize:Int = 100, startingSize:Int = 1000) {
		#if (threads || sys)
		// Binary semaphore for mutual exclusion (Mutex)
		semaphore = new Semaphore(1);
		#end

		lastMax = startingSize;
		_incrementSize = increaseSize;
		availableIndexes = [];

		// Pre-populate the pool with indexes from 0 to startingSize-1.
		// They are added in REVERSE order to simulate a Stack.
		// The Haxe Array acts like a Stack where push() adds to the END (top)
		// and pop() removes from the END (top).
		// C# logic: Enumerable.Range(0, _lastMax).Reverse()
		// -> { _lastMax-1, ..., 1, 0 }
		// -> Stack becomes [0] (top), [1], ..., [_lastMax-1] (bottom).
		// -> Pop() returns 0 first.
		//
		// So, for startingSize=10:
		// i goes from 0 to 9.
		// We push startingSize - 1 - i.
		// i=0: push(10-1-0) = push(9)
		// i=1: push(10-1-1) = push(8)
		// ...
		// i=9: push(10-1-9) = push(0)
		// Result: availableIndexes = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
		// availableIndexes.pop() -> 0 (first allocated index).
		for (i in 0...startingSize) {
			availableIndexes.push(startingSize - 1 - i);
		}
		// Post-condition: availableIndexes = [startingSize-1, ..., 1, 0]
		// availableIndexes.length = startingSize.
		// availableIndexes.pop() returns 0.
	}

	function get_incrementSize():Int {
		return _incrementSize;
	}

	/** 
	 * Allocates an instance (an index) from the pool. 
	 * Indexes are allocated in ascending order: 0, 1, 2, ... 
	 * @return An available index. 
	 */
	public function allocateInstance():Int {
		#if (threads || sys)
		semaphore.acquire();
		#end

		// Manual simulation of try-finally logic
		var errorOccurred = false;
		var caughtError:Dynamic = null;
		var result:Int = 0;

		if (availableIndexes.length == 0) {
			// Manual simulation of expand() error handling
			var expandErrorOccurred = false;
			var expandCaughtError:Dynamic = null;
			try {
				expand(); // Expand by default incrementSize
			} catch (e:Dynamic) {
				expandErrorOccurred = true;
				expandCaughtError = e;
			}

			if (expandErrorOccurred) {
				#if (threads || sys)
				semaphore.release();
				#end
				throw expandCaughtError;
			}
		}

		if (availableIndexes.length == 0) {
			#if (threads || sys)
			semaphore.release();
			#end
			throw "No index available after expansion";
		}

		// Pop the index from the top/end of the stack/array.
		// Since indexes were pushed in reverse order, pop() returns the lowest available index first.
		// For IndexPool(10, 10), after init: [9,8,7,6,5,4,3,2,1,0]. pop() -> 0.
		var index = availableIndexes.pop();
		if (index == null) { // Extra safety, though pop() on [] returns null anyway.
			#if (threads || sys)
			semaphore.release();
			#end
			throw "No index available after check";
		}
		result = index;

		#if (threads || sys)
		semaphore.release();
		#end

		return result;
	}

	/** 
	 * Releases an index back to the pool, making it available for future allocations. 
	 * @param index The index to release. 
	 */
	public function releaseInstance(index:Int):Void {
		if (index < 0) {
			throw "Index must be >= 0";
		}

		#if (threads || sys)
		semaphore.acquire();
		#end

		// Manual simulation of try-finally logic
		var errorOccurred = false;
		var caughtError:Dynamic = null;

		if (index >= lastMax) { // If index is beyond current range, expand
			// Manual simulation of expand() error handling
			var expandErrorOccurred = false;
			var expandCaughtError:Dynamic = null;
			try {
				// Expand to accommodate the index.
				// Pass index+1 to ensure index is within the logical range after expansion.
				// If index=15, lastMax=10. We want indexes 10..15 available.
				// expand(16) -> increaseBy = 16-10=6. Add 10,11,12,13,14,15.
				expand(index + 1);
			} catch (e:Dynamic) {
				expandErrorOccurred = true;
				expandCaughtError = e;
			}

			if (expandErrorOccurred) {
				#if (threads || sys)
				semaphore.release();
				#end
				throw expandCaughtError;
			}
		}

		// Add the index back to the pool.
		// C# Stack allows duplicates. Haxe Array also allows it.
		// Pushing to the end/top.
		// We push to the END of the array, maintaining the stack property.
		// The position in the stack doesn't matter much for correctness,
		// as long as it's available for future pop() calls.
		// Pushing to the end is simplest and consistent with initialization.
		availableIndexes.push(index);

		#if (threads || sys)
		semaphore.release();
		#end
	}

	/** 
	 * Expands the pool. 
	 * @param newIndex Optional. If provided, expands the pool to include this index. 
	 * If null, expands by incrementSize. 
	 */
	public function expand(?newIndex:Int):Void {
		// This function is called from within other methods that have already acquired the semaphore.
		// Therefore, it does NOT acquire the semaphore itself.

		var increaseBy = 0;
		if (newIndex != null) {
			// Logic: Calculate how many new indexes we need to add.
			// C# logic: increaseBy = (newIndex + 1) - _lastMax;
			// This ensures that if newIndex=5 and _lastMax=3,
			// we add indexes 3, 4, 5. (increaseBy = 6-3 = 3).
			// If newIndex=5 and _lastMax=6, increaseBy = 6-6 = 0. No expansion needed.
			increaseBy = (newIndex + 1) - lastMax;
			if (increaseBy <= 0) { increaseBy = 0; }
		} else {
			// If newIndex is null, expand by the default increment size.
			increaseBy = _incrementSize;
		}

		// C# has: if (increaseBy <= 0){ return; }
		// This protects against negative or zero increases.
		// It also handles the case where newIndex + 1 <= lastMax.
		if (increaseBy <= 0) {
			return;
		}

		// Now, add the new indexes.
		// C# logic:
		// 1. var newEntries = Enumerable.Range(_lastMax, increaseBy).Reverse();
		// Range(_lastMax, increaseBy) -> {_lastMax, _lastMax+1, ..., _lastMax + increaseBy - 1}
		// Reverse() -> {_lastMax + increaseBy - 1, ..., _lastMax+1, _lastMax}
		// 2. foreach(var entry in newEntries) { AvailableIndexes.Push(entry); }
		// Push(_lastMax + increaseBy - 1), ..., Push(_lastMax+1), Push(_lastMax)
		// Stack becomes [..., old_end, _lastMax + increaseBy - 1, ..., _lastMax+1, _lastMax]
		// Next Pop() -> _lastMax.
		//
		// Haxe Array simulation to achieve the same final stack state:
		// We want to add the new range {_lastMax, ..., _lastMax + increaseBy - 1}
		// to the END of availableIndexes in REVERSED order, so that pop()
		// retrieves them in the correct ASCENDING order.
		//
		// Method: Iterate from the END of the new range DOWN TO the START
		// and push() each element. This places them at the end/top of the array
		// in the correct stack order.
		//
		// Start index for the range is lastMax.
		// End index (inclusive) is lastMax + increaseBy - 1.
		var startIndex = lastMax;
		var endIndexInclusive = lastMax + increaseBy - 1;

		// Push entries from endIndexInclusive down to startIndex
		// This is equivalent to iterating the reversed C# Range and pushing.
		var i = endIndexInclusive;
		while (i >= startIndex) {
			availableIndexes.push(i); // Add to the end/top of the stack/array
			i--;
		}

		// Finally, update the upper bound marker.
		// C# logic: _lastMax += increaseBy;
		lastMax += increaseBy;
	}

	/** 
	 * Clears the pool, removing all available indexes. 
	 */
	public function clear():Void {
		#if (threads || sys)
		semaphore.acquire();
		#end

		// Manual simulation of try-finally logic
		lastMax = 0;
		availableIndexes.resize(0); // Clear the array

		#if (threads || sys)
		semaphore.release();
		#end
	}
}