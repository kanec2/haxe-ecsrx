package tests.mocks;

import systemsrx.computeds.Unit;
import rx.Observable;
import rx.Subject;
import systemsrx.computeds.data.ComputedFromData;

// Вспомогательный класс с ошибкой в transform
// Вспомогательный класс с ошибкой в transform, которая бросается при вызове getData()
class FaultyTransformComputedFromData extends ComputedFromData<Int, FaultyDataSource> {
	public var manuallyRefresh:Subject<Unit>;
	public var shouldThrowOnTransform:Bool = false;

	public function new(dataSource:FaultyDataSource) {
		this.manuallyRefresh = new rx.Subject<Unit>(); // Subject.create<Unit>()
		super(dataSource);
	}

	public function refreshWhen():Observable<Unit> {
		return manuallyRefresh;
	}

	public function transform(dataSource:FaultyDataSource):Int {
		// ИСПРАВЛЕНИЕ: Бросаем исключение при вызове transform(), если shouldThrowOnTransform=true
		if (shouldThrowOnTransform) {
			throw "Transform error";
		}
		return dataSource.data;
	}
}