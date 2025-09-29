package ecsrxe.groups.observable;

import ecsrxe.collections.entity.INotifyingCollection;
import ecsrxe.entities.IEntity;
import ecsrxe.groups.observable.ObservableGroupToken;

/** 
 * Configuration for an observable group. 
 * Contains the token, notifying collections, and initial entities. 
 */
@:structInit
class ObservableGroupConfiguration {
	/** 
	 * The token that describes the observable group. 
	 */
	public var observableGroupToken(default, null):ObservableGroupToken;

	/** 
	 * The notifying collections to observe for entity changes. 
	 */
	public var notifyingCollections(default, null):Iterable<INotifyingCollection>;

	/** 
	 * The initial entities to populate the group with. 
	 */
	public var initialEntities(default, null):Iterable<IEntity>;

	public function new(observableGroupToken:ObservableGroupToken, ?notifyingCollections:Iterable<INotifyingCollection>, ?initialEntities:Iterable<IEntity>) {
		this.observableGroupToken = observableGroupToken;
		this.notifyingCollections = notifyingCollections != null ? notifyingCollections : [];
		this.initialEntities = initialEntities != null ? initialEntities : [];
	}
}