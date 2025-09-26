package systemsrx.factories; /** * Generic factory interface for creating instances of type Tout. * In C#, this would be IFactory<out Tout>. Haxe does not support 'out' variance. */ 
interface IFactoryGeneric<Tout> extends IFactory {
    /** * Creates a new instance of type Tout. * 
     * @return A new instance. */ 
     function create():Tout;

}