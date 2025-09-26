package ecsrxe.groups.observable;

import ecsrxe.groups.LookupGroup;

/** 
 * A readonly struct that represents a token for an observable group. 
 * It contains both the LookupGroup and the specific collection IDs it should be targeting. 
 */
@:structInit
class ObservableGroupToken /*implements IEquatable<ObservableGroupToken>*/ {
	/** 
	 * The underlying LookupGroup that describes the component requirements. 
	 */
	public var lookupGroup(default, null):LookupGroup;

	/** 
	 * The specific collection IDs this token should be targeting. 
	 * If null or empty, it targets all collections. 
	 */
	public var collectionIds(default, null):Array<Int>;

	/** 
	 * Creates a new ObservableGroupToken. 
	 * @param withComponents The component type IDs that are required. 
	 * @param withoutComponents The component type IDs that are excluded. 
	 * @param collectionIds The specific collection IDs to target (optional). 
	 */
	public function new(withComponents:Array<Int>, withoutComponents:Array<Int>, ?collectionIds:Array<Int>) {
		this.lookupGroup = new LookupGroup(withComponents, withoutComponents);
		this.collectionIds = collectionIds != null ? collectionIds : [];
	}

	/** 
	 * Creates a new ObservableGroupToken from an existing LookupGroup. 
	 * @param lookupGroup The LookupGroup to use. 
	 * @param collectionIds The specific collection IDs to target (optional). 
	 */
	public function fromLookupGroup(lookupGroup:LookupGroup, ?collectionIds:Array<Int>) {
		this.lookupGroup = lookupGroup;
		this.collectionIds = collectionIds != null ? collectionIds : [];
	}

	/** 
	 * Checks if this ObservableGroupToken is equal to another ObservableGroupToken. 
	 * Two tokens are equal if they have the same LookupGroup and CollectionIds. 
	 * @param other The other ObservableGroupToken to compare to. 
	 * @return true if the tokens are equal, false otherwise. 
	 */
	public function equals(other:ObservableGroupToken):Bool {
		if (other == null)
			return false;

		// Сравниваем LookupGroup с помощью его equals метода
		var lookupGroupsEqual = lookupGroup.equals(other.lookupGroup);

		// Сравниваем CollectionIds с помощью структурного сравнения массивов
		var collectionIdsEqual = arrayEquals(collectionIds, other.collectionIds);

		return lookupGroupsEqual && collectionIdsEqual;
	}

	/** 
	 * Gets the hash code for this ObservableGroupToken. 
	 * @return The hash code. 
	 */
	public function hashCode():Int {
		// В C# было override int GetHashCode()
		// unchecked block в C# позволяет арифметике переполняться без исключений
		// В Haxe арифметика по умолчанию допускает переполнение

		// Используем хэширование составных частей
		var lookupHash = lookupGroup.hashCode();
		var poolHash = 0;
		if (collectionIds != null) {
			poolHash = arrayHashCode(collectionIds);
		}
		return lookupHash ^ poolHash;
	}

	/** 
	 * Returns a string representation of the ObservableGroupToken. 
	 * @return A string representation. 
	 */
	public function toString():String {
		// В C# было override string ToString()
		return 'ObservableGroupToken(lookupGroup: $lookupGroup, collectionIds: ${collectionIds != null ? collectionIds.toString() : "null"})';
	}

	// Вспомогательные функции для структурного сравнения и хэширования массивов

	/** 
	 * Compares two arrays for structural equality. 
	 * @param a The first array. 
	 * @param b The second array. 
	 * @return true if the arrays are structurally equal, false otherwise. 
	 */
	static function arrayEquals(a:Array<Int>, b:Array<Int>):Bool {
		if (a == null && b == null)
			return true;
		if (a == null || b == null)
			return false;
		if (a.length != b.length)
			return false;
		for (i in 0...a.length) {
			if (a[i] != b[i])
				return false;
		}
		return true;
	}

	/** 
	 * Calculates a structural hash code for an array. 
	 * @param arr The array to hash. 
	 * @return The hash code. 
	 */
	static function arrayHashCode(arr:Array<Int>):Int {
		if (arr == null)
			return 0;

		var hash = 0;
		for (i in 0...arr.length) {
			// unchecked в C#:
			// hash = (hash * 31) + (arr[i] != null ? arr[i].GetHashCode() : 0);
			// В Haxe для Int GetHashCode() это просто само значение
			hash = (hash * 31) + arr[i]; // Int.hashCode() == Int
		}
		return hash;
	}
}