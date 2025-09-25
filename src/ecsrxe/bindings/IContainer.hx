package ecsrx.bindings;

interface IContainer {
	function bind<T>():IBindingBuilder<T>;
	function unbind<T>(type:Class<T>):Void;
	function resolve<T>(type:Class<T>):T;
	function hasBinding<T>(type:Class<T>):Bool;
	function dispose():Void;
}