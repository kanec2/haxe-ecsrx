package ecsrxe.groups;

/** 
 * A readonly struct that represents a group of components by their type IDs. 
 * Used for fast lookup in entity collections. 
 */
@:structInit
class LookupGroup /*implements IEquatable<LookupGroup>*/ {
	/** 
	 * The component type IDs that are required for an entity to belong to this group. 
	 */
	public var requiredComponents(default, null):Array<Int>;

	/** 
	 * The component type IDs that are excluded for an entity to belong to this group. 
	 */
	public var excludedComponents(default, null):Array<Int>;

	/** 
	 * Creates a new LookupGroup. 
	 * @param requiredComponents The component type IDs that are required. 
	 * @param excludedComponents The component type IDs that are excluded. 
	 */
	public function new(requiredComponents:Array<Int>, excludedComponents:Array<Int>) {
		// В C# это readonly struct, поэтому в Haxe мы просто храним ссылки
		// Без глубокого копирования, как в C# readonly поля
		this.requiredComponents = requiredComponents;
		this.excludedComponents = excludedComponents;
	}

	/** 
	 * Checks if this LookupGroup is equal to another LookupGroup. 
	 * Two LookupGroups are equal if they have the same required and excluded component type IDs. 
	 * @param other The other LookupGroup to compare to. 
	 * @return true if the LookupGroups are equal, false otherwise. 
	 */
	public function equals(other:LookupGroup):Bool {
		if (other == null)
			return false;

		// Используем собственную реализацию структурного сравнения массивов
		// В C# было StructuralComparisons.StructuralEqualityComparer.Equals
		return arrayEquals(requiredComponents, other.requiredComponents) && arrayEquals(excludedComponents, other.excludedComponents);
	}

	/** 
	 * Checks if this LookupGroup is equal to another object. 
	 * @param obj The other object to compare to. 
	 * @return true if the objects are equal, false otherwise. 
	 */
	public function equalsObj(obj:Dynamic):Bool {
		// В C# было override bool Equals(object obj)
		if (obj == null)
			return false;
		// Проверяем, является ли obj экземпляром LookupGroup
		// В Haxe это делается через Std.is
		if (Std.is(obj, LookupGroup)) {
			var other:LookupGroup = cast obj;
			return equals(other);
		}
		return false;
	}

	/** 
	 * Gets the hash code for this LookupGroup. 
	 * @return The hash code. 
	 */
	public function hashCode():Int {
		// В C# было override int GetHashCode()
		// unchecked block в C# позволяет арифметике переполняться без исключений
		// В Haxe арифметика по умолчанию допускает переполнение

		// Используем собственную реализацию структурного хэширования массивов
		// В C# было StructuralComparisons.StructuralEqualityComparer.GetHashCode
		var requiredComponentsHash = 0;
		if (requiredComponents != null) {
			requiredComponentsHash = arrayHashCode(requiredComponents);
		}

		var excludedComponentsHash = 0;
		if (excludedComponents != null) {
			excludedComponentsHash = arrayHashCode(excludedComponents);
		}

		// unchecked в C#:
		// return ((requiredComponentsHash * 397) ^ excludedComponentsHash);
		// В Haxe просто выполняем арифметику
		return ((requiredComponentsHash * 397) ^ excludedComponentsHash);
	}

	/** 
	 * Implements the == operator for LookupGroup. 
	 * @param left The left operand. 
	 * @param right The right operand. 
	 * @return true if the operands are equal, false otherwise. 
	 */
	@:op(A == B)
	static public function equalsOp(left:LookupGroup, right:LookupGroup):Bool {
		// В C# было static bool operator ==(LookupGroup left, LookupGroup right)
		if (left == null && right == null)
			return true;
		if (left == null || right == null)
			return false;
		return left.equals(right);
	}

	/** 
	 * Implements the != operator for LookupGroup. 
	 * @param left The left operand. 
	 * @param right The right operand. 
	 * @return true if the operands are not equal, false otherwise. 
	 */
	@:op(A != B)
	static public function notEqualsOp(left:LookupGroup, right:LookupGroup):Bool {
		// В C# было static bool operator !=(LookupGroup left, LookupGroup right)
		return !(left == right); // Используем == оператор
	}

	// Вспомогательные функции для структурного сравнения и хэширования массивов

	/** 
	 * Compares two arrays for structural equality. 
	 * @param a The first array. 
	 * @param b The second array. 
	 * @return true if the arrays are structurally equal, false otherwise. 
	 */
	static function arrayEquals(a:Array<Int>, b:Array<Int>):Bool {
		// В C# было StructuralComparisons.StructuralEqualityComparer.Equals
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
		// В C# было StructuralComparisons.StructuralEqualityComparer.GetHashCode
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

	/** 
	 * Returns a string representation of the LookupGroup. 
	 * @return A string representation. 
	 */
	public function toString():String {
		// В C# было override string ToString()
		return
			'LookupGroup(required: ${requiredComponents != null ? requiredComponents.toString() : "null"}, excluded: ${excludedComponents != null ? excludedComponents.toString() : "null"})';
	}
}