package ecsrxe.groups.observable;

import systemsrx.factories.IFactory;
import ecsrxe.groups.observable.ObservableGroupConfiguration;
import ecsrxe.groups.observable.IObservableGroup;

/** 
 * Factory for creating observable groups from configurations. 
 * This interface extends IFactory<ObservableGroupConfiguration, IObservableGroup> 
 * to provide a way to create observable groups with specific configurations. 
 */
interface IObservableGroupFactory extends IFactory<ObservableGroupConfiguration, IObservableGroup> {
	// Наследует метод create(config:ObservableGroupConfiguration):IObservableGroup от IFactory
}