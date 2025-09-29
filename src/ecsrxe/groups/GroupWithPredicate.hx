package ecsrxe.groups;

import ecsrxe.entities.IEntity;
import ecsrxe.groups.Group;
import ecsrxe.groups.IHasPredicate;
#if (threads || sys)
import haxe.ds.Map; // Для Dictionary

#end

/** 
 * A group with a predicate that filters entities. 
 */
@:keep
class GroupWithPredicate extends Group implements IHasPredicate {
	#if (threads || sys)
	public var entityPredicate(default, null):IEntity->Bool;
	#end

	/** 
	 * Creates a new GroupWithPredicate. 
	 * @param entityPredicate The predicate to filter entities. 
	 * @param requiredComponents The required component types. 
	 */
	public function new(entityPredicate:IEntity->Bool, requiredComponents:Array<Class<Dynamic>>, ?excludedComponents:Array<Class<Dynamic>>) {
		#if (threads || sys)
		this.entityPredicate = entityPredicate;
		// Вызываем конструктор родителя Group с requiredComponents и excludedComponents
		super(requiredComponents, excludedComponents != null ? excludedComponents : []);
		#end
	}

	/** 
	 * Checks if the entity can be processed by this group. 
	 * @param entity The entity to check. 
	 * @return true if the entity can be processed, false otherwise. 
	 */
	public function canProcessEntity(entity:IEntity):Bool {
		#if (threads || sys)
		// В C# было: EntityPredicate == null || EntityPredicate(entity)
		// В Haxe используем entityPredicate == null || entityPredicate(entity)
		return entityPredicate == null || entityPredicate(entity);
		#else
		return false; // Заглушка для платформ без поддержки
		#end
	}
}