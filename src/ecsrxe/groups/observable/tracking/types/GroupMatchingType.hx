package ecsrxe.groups.observable.tracking.types;

/** 
 * Enum for group matching types. 
 * Represents the different ways an entity can match or not match a group. 
 */
@:enum
abstract GroupMatchingType(Int) from Int to Int {
	/** 
	 * No matches found for the entity in the group. 
	 */
	var NoMatchesFound = 0;

	/** 
	 * Entity matches the group with no exclusions. 
	 */
	var MatchesNoExcludes = 1;

	/** 
	 * Entity matches the group with exclusions. 
	 */
	var MatchesWithExcludes = 2;

	/** 
	 * Entity does not match the group but has exclusions. 
	 */
	var NoMatchesWithExcludes = 3;

	/** 
	 * Entity does not match the group and has no exclusions. 
	 */
	var NoMatchesNoExcludes = 4;

	/** 
	 * Gets the string representation of the enum value. 
	 * @return The string representation. 
	 */
	public function toString():String {
		return switch (this) {
			case NoMatchesFound:
				"NoMatchesFound";

			case MatchesNoExcludes:
				"MatchesNoExcludes";

			case MatchesWithExcludes:
				"MatchesWithExcludes";

			case NoMatchesWithExcludes:
				"NoMatchesWithExcludes";

			case NoMatchesNoExcludes:
				"NoMatchesNoExcludes";

			default: "Unknown";
		}
	}

	/** 
	 * Gets the enum value from its string representation. 
	 * @param str The string representation. 
	 * @return The enum value. 
	 */
	static public function fromString(str:String):GroupMatchingType {
		return switch (str) {
			case "NoMatchesFound":
				NoMatchesFound;

			case "MatchesNoExcludes":
				MatchesNoExcludes;

			case "MatchesWithExcludes":
				MatchesWithExcludes;

			case "NoMatchesWithExcludes":
				NoMatchesWithExcludes;

			case "NoMatchesNoExcludes":
				NoMatchesNoExcludes;

			default: NoMatchesFound;
		}
	}

	/** 
	 * Gets the enum value from its int representation. 
	 * @param value The int representation. 
	 * @return The enum value. 
	 */
	static public function fromInt(value:Int):GroupMatchingType {
		return switch (value) {
			case 0:
				NoMatchesFound;

			case 1:
				MatchesNoExcludes;

			case 2:
				MatchesWithExcludes;

			case 3:
				NoMatchesWithExcludes;

			case 4:
				NoMatchesNoExcludes;

			default: NoMatchesFound;
		}
	}
}