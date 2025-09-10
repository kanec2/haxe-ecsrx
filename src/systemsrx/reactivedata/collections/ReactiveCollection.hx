package systemsrx.reactivedata.collections; #if (threads || sys) import rx.Observable;

import rx.Subject;
import rx.disposables.ISubscription; #end import systemsrx.computeds.Unit;

// Используем Unit из computeds

/** * Reactive collection implementation. * This code is adapted from UniRx project by neuecc (https://github.com/neuecc/UniRx). * @typeparam T The type of elements in the collection. */
@:keep class ReactiveCollection<T> implements IReactiveCollection<T> {
	#if (threads || sys)
	var isDisposed:Bool = false;
	var items:Array<T> = null;
	// Внутреннее хранилище элементов
	// Subjects for notifications
	var countChanged:Subject<Int> = null;
	var collectionReset:Subject<Unit> = null;
	var collectionAdd:Subject<CollectionAddEvent<T>> = null;
	var collectionMove:Subject<CollectionMoveEvent<T>> = null;
	var collectionRemove:Subject<CollectionRemoveEvent<T>> = null;
	var collectionReplace:Subject<CollectionReplaceEvent<T>> = null;

	public function new(?collection:Iterable<T>) {
		this.items = new Array<T>();
		this.isDisposed = false;
		if (collection != null) {
			for (item in collection) {
				push(item);
			}
		}
	}

	// Реализация IReactiveCollection<T> и IReadOnlyReactiveCollection<T>
	// Доступ к элементам
	public function get(index:Int):T {
		if (index < 0 || index >= items.length) {
			throw "Index out of bounds";
		}
		return items[index];
	}

	public function set(index:Int, value:T):T {
		if (index < 0 || index >= items.length) {
			throw "Index out of bounds";
		}
		setItem(index, value);
		return value;
	}

	// Длина коллекции
	public var count(get, null):Int;

	function get_count():Int {
		return items.length;
	}

	// Методы для изменения коллекции
	public function push(item:T):Int {
		var index = items.length;
		insertItem(index, item);
		return index + 1;
		// Возвращаем новую длину, как Array.push
	}

	public function insert(index:Int, item:T):Void {
		if (index < 0 || index > items.length) {
			throw "Index out of bounds";
		}
		insertItem(index, item);
	}

	public function removeAt(index:Int):Void {
		if (index < 0 || index >= items.length) {
			throw "Index out of bounds";
		}
		removeItem(index);
	}

	public function clear():Void {
		clearItems();
	}

	public function move(oldIndex:Int, newIndex:Int):Void {
		if (oldIndex < 0 || oldIndex >= items.length || newIndex < 0 || newIndex >= items.length) {
			throw "Index out of bounds";
		}
		moveItem(oldIndex, newIndex);
	}

	// Observable методы
	public function observeCountChanged(notifyCurrentCount:Bool = false):Observable<Int> {
		if (isDisposed) {
			return Observable.empty();
			// ImmutableEmptyObservable<Int>.Instance в C#
		}
		var subject = countChanged;
		if (subject == null) {
			subject = countChanged = new rx.Subject<Int>();
			// Subject.create<Int>()
		}
		if (notifyCurrentCount) {
			// Используем правильное имя метода из RxHaxe Subject
			subject.on_next(count);
		}
		return subject;
	}

	public function observeReset():Observable<Unit> {
		if (isDisposed) {
			return Observable.empty();
			// ImmutableEmptyObservable<Unit>.Instance
		}
		var subject = collectionReset;
		if (subject == null) {
			subject = collectionReset = new rx.Subject<Unit>();
			// Subject.create<Unit>()
		}
		return subject;
	}

	public function observeAdd():Observable<CollectionAddEvent<T>> {
		if (isDisposed) {
			return Observable.empty();
			// ImmutableEmptyObservable<CollectionAddEvent<T>>.Instance
		}
		var subject = collectionAdd;
		if (subject == null) {
			subject = collectionAdd = new rx.Subject<CollectionAddEvent<T>>();
			// Subject.create<CollectionAddEvent<T>>()
		}
		return subject;
	}

	public function observeMove():Observable<CollectionMoveEvent<T>> {
		if (isDisposed) {
			return Observable.empty();
			// ImmutableEmptyObservable<CollectionMoveEvent<T>>.Instance
		}
		var subject = collectionMove;
		if (subject == null) {
			subject = collectionMove = new rx.Subject<CollectionMoveEvent<T>>();
			// Subject.create<CollectionMoveEvent<T>>()
		}
		return subject;
	}

	public function observeRemove():Observable<CollectionRemoveEvent<T>> {
		if (isDisposed) {
			return Observable.empty();
			// ImmutableEmptyObservable<CollectionRemoveEvent<T>>.Instance
		}
		var subject = collectionRemove;
		if (subject == null) {
			subject = collectionRemove = new rx.Subject<CollectionRemoveEvent<T>>();
			// Subject.create<CollectionRemoveEvent<T>>()
		}
		return subject;
	}

	public function observeReplace():Observable<CollectionReplaceEvent<T>> {
		if (isDisposed) {
			return Observable.empty();
			// ImmutableEmptyObservable<CollectionReplaceEvent<T>>.Instance
		}
		var subject = collectionReplace;
		if (subject == null) {
			subject = collectionReplace = new rx.Subject<CollectionReplaceEvent<T>>();
			// Subject.create<CollectionReplaceEvent<T>>()
		}
		return subject;
	}

	// Iterable<T> метод
	public function iterator():Iterator<T> {
		return items.iterator();
	}

	// IDisposable метод
	public function dispose():Void {
		disposeInternal(true);
	}

	// Внутренние методы (protected в C#)
	function clearItems():Void {
		var beforeCount = count;
		items = new Array<T>();
		// Простая очистка массива
		if (collectionReset != null) {
			collectionReset.on_next(Unit.instance);
			// Используем Unit.instance
		}
		if (beforeCount > 0 && countChanged != null) {
			countChanged.on_next(count);
		}
	}

	function insertItem(index:Int, item:T):Void {
		items.insert(index, item);
		if (collectionAdd != null) {
			collectionAdd.on_next(new CollectionAddEvent<T>(index, item));
		}
		if (countChanged != null) {
			countChanged.on_next(count);
		}
	}

	function moveItem(oldIndex:Int, newIndex:Int):Void {
		var item = items[oldIndex];
		items.splice(oldIndex, 1);
		items.insert(newIndex, item);
		if (collectionMove != null) {
			collectionMove.on_next(new CollectionMoveEvent<T>(oldIndex, newIndex, item));
		}
	}

	function removeItem(index:Int):Void {
		var item = items[index];
		items.splice(index, 1);
		if (collectionRemove != null) {
			collectionRemove.on_next(new CollectionRemoveEvent<T>(index, item));
		}
		if (countChanged != null) {
			countChanged.on_next(count);
		}
	}

	function setItem(index:Int, item:T):Void {
		var oldItem = items[index];
		items[index] = item;
		if (collectionReplace != null) {
			collectionReplace.on_next(new CollectionReplaceEvent<T>(index, oldItem, item));
		}
	}

	// Методы для освобождения ресурсов
	function disposeSubject<TSubject>(subject:Subject<TSubject>):Void {
		if (subject == null) {
			return;
		}
		try {
			subject.on_completed();
			// Используем правильное имя метода
		}
		finally
		{
			// Subject в RxHaxe может не иметь dispose(), или он может быть в ISubscription
			// Предположим, что Subject сам управляет ресурсами или unsubscribe() достаточно
			// subject.dispose();
			// Закомментировано, так как может не существовать
		}
	}

	function disposeInternal(disposing:Bool):Void {
		if (isDisposed) {
			return;
		}
		if (disposing) {
			disposeSubject(collectionReset);
			collectionReset = null;
			disposeSubject(collectionAdd);
			collectionAdd = null;
			disposeSubject(collectionMove);
			collectionMove = null;
			disposeSubject(collectionRemove);
			collectionRemove = null;
			disposeSubject(collectionReplace);
			collectionReplace = null;
			disposeSubject(countChanged);
			countChanged = null;
		}
		isDisposed = true;
		items = null;
		// Освобождаем ссылку на массив
	}
	#else
	// Заглушка для платформ без поддержки
	public var count(get, null):Int;

	function get_count():Int
		return 0;

	public function new(?collection:Iterable<T>) {}

	public function get(index:Int):T
		return cast null;

	public function set(index:Int, value:T):T
		return value;

	public function push(item:T):Int
		return 0;

	public function insert(index:Int, item:T):Void {}

	public function removeAt(index:Int):Void {}

	public function clear():Void {}

	public function move(oldIndex:Int, newIndex:Int):Void {}

	public function observeCountChanged(notifyCurrentCount:Bool = false):rx.Observable<Int> {
		return null;
	}

	public function observeReset():rx.Observable<systemsrx.computeds.Unit> {
		return null;
	}

	public function observeAdd():rx.Observable<CollectionAddEvent<T>> {
		return null;
	}

	public function observeMove():rx.Observable<CollectionMoveEvent<T>> {
		return null;
	}

	public function observeRemove():rx.Observable<CollectionRemoveEvent<T>> {
		return null;
	}

	public function observeReplace():rx.Observable<CollectionReplaceEvent<T>> {
		return null;
	}

	public function iterator():Iterator<T> {
		return [].iterator();
	}

	public function dispose():Void {}

	function clearItems():Void {}

	function insertItem(index:Int, item:T):Void {}

	function moveItem(oldIndex:Int, newIndex:Int):Void {}

	function removeItem(index:Int):Void {}

	function setItem(index:Int, item:T):Void {}

	function disposeSubject<TSubject>(subject:Dynamic):Void {}

	function disposeInternal(disposing:Bool):Void {}
	#end
}