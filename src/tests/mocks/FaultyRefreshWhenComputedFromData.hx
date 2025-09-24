package tests.mocks;

import systemsrx.computeds.Unit;
import rx.Observable;
import systemsrx.computeds.data.ComputedFromData;

// Вспомогательный класс с ошибкой в refreshWhen
class FaultyRefreshWhenComputedFromData extends ComputedFromData<Int, FaultyDataSource> {
	public var shouldThrow:Bool = false;

	public function new(dataSource:FaultyDataSource, throwEx:Bool = true) {
        trace("FaultyRefreshWhenComputedFromData. Created");
        shouldThrow = throwEx;
		super(dataSource);
	}

	public function refreshWhen():Observable<Unit> {
        trace("FaultyRefreshWhenComputedFromData. Refresh when begin. should throw is "+shouldThrow);
		if (shouldThrow) {
            trace("FaultyRefreshWhenComputedFromData. Err throwed");
			throw "RefreshWhen error"; // Бросаем исключение, если shouldThrow=true
		}
		// Возвращаем пустой Observable, который никогда не испускает значений
		return Observable.empty();
	}

	public function transform(dataSource:FaultyDataSource):Int {
        trace("FaultyRefreshWhenComputedFromData. Transform called");
		return dataSource.data;
	}
}