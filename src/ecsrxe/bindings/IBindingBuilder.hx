package ecsrx.bindings;

interface IBindingBuilder<T> {
	function to(instance:T):IBindingBuilder<T>;
	function toType(type:Class<T>):IBindingBuilder<T>;
	function toMethod(factory:Void->T):IBindingBuilder<T>;
	function asSingleton():IBindingBuilder<T>;
	function asTransient():IBindingBuilder<T>;
	function when(condition:String->Bool):IBindingBuilder<T>;
}