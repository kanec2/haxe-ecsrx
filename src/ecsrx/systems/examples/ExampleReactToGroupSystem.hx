package ecsrx.systems.examples;

import ecsrx.systems.AbstractReactToGroupSystem;
import ecsrx.collections.ICollection;
import rx.Observable;
import rx.Subject;

class ExampleReactToGroupSystem extends AbstractReactToGroupSystem {
	private var _collection:ICollection;
	private var _subject:Subject<ICollection>;

	public function new(collection:ICollection) {
		super("ExampleReactToGroupSystem", 200);
		this._collection = collection;
	}

	override public function reactToGroup():Observable<ICollection> {
		// Реагируем на изменения в коллекции
		return _collection.observable.map(function(_) {
			return _collection;
		});
	}

	override public function process(collection:ICollection):Void {
		trace('ReactToGroup system processing collection with ${collection.count()} entities');
	}
}