package ecsrxe.groups.observable.tracking.types;

/** 
 * Enum for group action types. 
 * Represents the different actions that can occur when an entity interacts with a group. 
 */
@:enum
abstract GroupActionType(Int) from Int to Int {
	/** 
	 * Unknown action. 
	 */
	var Unknown = 0;

	/** 
	 * Entity joined the group. 
	 */
	var JoinedGroup = 1;

	/** 
	 * Entity is leaving the group. 
	 */
	var LeavingGroup = 2;

	/** 
	 * Entity left the group. 
	 */
	var LeftGroup = 3;

	/** 
	 * Gets the string representation of the enum value. 
	 * @return The string representation. 
	 */
	public function toString():String {
		return switch (this) {
			case Unknown: "Unknown";
			case JoinedGroup: "JoinedGroup";
			case LeavingGroup: "LeavingGroup";
			case LeftGroup: "LeftGroup";
			default: "Unknown";
		}
	}

	/** 
	 * Gets the enum value from its string representation. 
	 * @param str The string representation. 
	 * @return The enum value. 
	 */
	static public function fromString(str:String):GroupActionType {
		return switch (str) {
			case "Unknown": Unknown;
			case "JoinedGroup": JoinedGroup;
			case "LeavingGroup": LeavingGroup;
			case "LeftGroup": LeftGroup;
			default: Unknown;
		}
	}

	/** 
	 * Gets the enum value from its int representation. 
	 * @param value The int representation. 
	 * @return The enum value. 
	 */
	static public function fromInt(value:Int):GroupActionType {
		return switch (value) {
			case 0: Unknown;
			case 1: JoinedGroup;
			case 2: LeavingGroup;
			case 3: LeftGroup;
			default: Unknown;
		}
	}
}