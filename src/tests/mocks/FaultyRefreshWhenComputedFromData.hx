package tests.mocks;

import systemsrx.computeds.Unit;
import rx.Observable;
import systemsrx.computeds.data.ComputedFromData;

// Вспомогательный класс с ошибкой в refreshWhen
class FaultyRefreshWhenComputedFromData extends ComputedFromData<Int, FaultyDataSource> {
	public var shouldThrow:Bool = false;

	public function new(dataSource:FaultyDataSource) {
		super(dataSource);
	}

	public function refreshWhen():Observable<Unit> {
		if (shouldThrow) {
			throw "RefreshWhen error";
		}
		// Возвращаем пустой Observable, который никогда не испускает значений
		return Observable.empty();
	}

	public function transform(dataSource:FaultyDataSource):Int {
		return dataSource.data;
	}
}