package ecsrxe.components.accessor;

/** 
 * A simple reference wrapper to emulate C#'s 'out' parameter passing. 
 * @typeparam T The type of the value to wrap. 
 */
@:structInit
class Ref<T> {
	/** 
	 * The value being wrapped. 
	 */
	public var value:T;

	/** 
	 * Creates a new Ref wrapper. 
	 * @param value The initial value to wrap (optional). 
	 */
	public function new(?value:T) {
		this.value = value;
	}
}