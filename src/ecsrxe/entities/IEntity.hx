package ecsrxe.entities;

import ecsrxe.components.IComponent;
import systemsrx.computeds.IComputed;
import rx.Observable;
#if (threads || sys)
import rx.disposables.ISubscription;
#end

/** 
 * A container for components, its only job is to let you compose components 
 */
interface IEntity /*implements IDisposable*/ {
	/** 
	 * Triggered every time components are added to the entity 
	 * If you are adding components individually it will be fired once per interaction, its better to batch them 
	 */
	var componentsAdded(get, null):Observable<Array<Int>>;

	/** 
	 * Triggered every time components are about to be removed from the entity 
	 * If you are removing components individually it will be fired once per interaction, its better to batch them 
	 */
	var componentsRemoving(get, null):Observable<Array<Int>>;

	/** 
	 * Triggered every time components have been removed removed from the entity 
	 * If you are removing components individually it will be fired once per interaction, its better to batch them 
	 */
	var componentsRemoved(get, null):Observable<Array<Int>>;

	/** 
	 * The Id of the entity 
	 * It is recommended you do not pass entities around and instead pass their ids around 
	 * and then use the collection/observable group methods to get the entity from its id 
	 */
	var id(default, null):Int;

	/** 
	 * All the components which have been applied to this entity 
	 */
	var components(get, null):Iterable<IComponent>;

	/** 
	 * All allocations of components in the component database 
	 */
	var componentAllocations(get, null):Array<Int>;

	/** 
	 * Adds all provided components to the entity 
	 * @param components The components to add 
	 */
	function addComponents(components:Array<IComponent>):Void;

	/** 
	 * Removes component types from the entity 
	 * @param componentsTypes The component types to remove 
	 */
	function removeComponents(componentsTypes:Array<Class<IComponent>>):Void;

	/** 
	 * Removes all the components from the entity 
	 */
	function removeAllComponents():Void;

	/** 
	 * Gets a component from the entity based upon its type or null if one cannot be found 
	 * @param componentType The type of component to retrieve 
	 * @return The component instance if found, or null if not 
	 */
	function getComponent(componentType:Class<IComponent>):IComponent;

	/** 
	 * Gets a component from the entity based upon its component type id 
	 * @param componentTypeId The id of the component type 
	 * @return The component instance if found, or null if not 
	 */
	function getComponentById(componentTypeId:Int):IComponent;

	/** 
	 * Gets a component from its type id 
	 * @param componentTypeId The component type id 
	 * @return The ref of the component 
	 * @remarks This is meant for struct based components 
	 */
	function getComponentRef<T:IComponent>(componentTypeId:Int):T;

	/** 
	 * Adds a component from its type id 
	 * @param componentTypeId The component type id 
	 * @return The ref of the component 
	 * @remarks This is meant for struct based components 
	 */
	function addComponentRef<T:IComponent>(componentTypeId:Int):T;

	/** 
	 * Updates a component from its type id with the new values 
	 * @param componentTypeId The component type id 
	 * @param newValue The struct containing new values 
	 * @remarks This is meant for struct based components 
	 */
	function updateComponent<T:IComponent>(componentTypeId:Int, newValue:T):Void;

	/** 
	 * Removes all components with matching type ids 
	 * @param componentsTypeIds The component type ids 
	 */
	function removeComponentsByIds(componentsTypeIds:Array<Int>):Void;

	/** 
	 * Checks to see if the entity contains the given component type 
	 * @param componentType Type of component to look for 
	 * @return true if the component can be found, false if it cant be 
	 */
	function hasComponent(componentType:Class<IComponent>):Bool;

	/** 
	 * Checks to see if the entity contains the given component based on its type id 
	 * @param componentTypeId Type id of component to look for 
	 * @return true if the component can be found, false if it cant be 
	 */
	function hasComponentById(componentTypeId:Int):Bool;

	/** 
	 * Disposes of all resources used by the entity 
	 */
	function dispose():Void;
}