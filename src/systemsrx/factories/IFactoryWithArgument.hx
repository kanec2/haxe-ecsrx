package systemsrx.factories; /** * Generic factory interface for creating instances of type Tout using an argument of type Tin. * In C#, this would be IFactory<in Tin, out Tout>. Haxe does not support 'in' or 'out' variance. */ interface IFactoryWithArgument<Tin,
	Tout> extends IFactory {/** * Creates a new instance of type Tout using the provided argument. * @param arg The argument to use for creation. * @return A new instance. */ function create(arg:Tin):Tout;

}