package tests.mocks;

import systemsrx.computeds.Unit;
import rx.Observable;
import rx.Subject;
import systemsrx.computeds.data.ComputedFromData;

// Вспомогательный класс с ошибкой в transform
class FaultyTransformComputedFromData extends ComputedFromData<Int, FaultyDataSource> {
	public var manuallyRefresh:Subject<Unit>;
	public var shouldThrow:Bool = false;

	public function new(dataSource:FaultyDataSource, throwexp:Bool = true) {
        trace("FaultyTransformComputedFromData. Created");
        shouldThrow = throwexp;
		this.manuallyRefresh = new rx.Subject<Unit>();
		super(dataSource);
	}

	public function refreshWhen():Observable<Unit> {
        trace("FaultyTransformComputedFromData. Refresh when begin");
		return manuallyRefresh;
	}

	public function transform(dataSource:FaultyDataSource):Int {
        trace("FaultyTransformComputedFromData. Transform called. should throw is "+shouldThrow);
		if (shouldThrow) {
            trace("FaultyTransformComputedFromData. Err throwed");
			throw "Transform error"; // Бросаем исключение, если shouldThrow=true
		}
		return dataSource.data;
	}
}