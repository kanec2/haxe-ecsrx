package systemsrx.reactivedata; /** * Interface for a reactive property that can be read and written. * @typeparam T The type of the value. */ interface IReactiveProperty<T> extends IReadOnlyReactiveProperty<T> {/** * Gets or sets the current value of the property. */ var value(get,
	set):T;

}