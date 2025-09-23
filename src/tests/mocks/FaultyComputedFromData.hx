package tests.mocks;

class FaultyComputedFromData extends ComputedFromData<Int, FaultyDataSource> {
    public var manuallyRefresh:Subject<Unit>;
    public var shouldThrow:Bool = false;

    public function new(data:FaultyDataSource) {
        super(data);
        this.manuallyRefresh = new rx.Subject<Unit>();
    }

    override public function refreshWhen():Observable<Unit> {
        return manuallyRefresh;
    }

    override public function transform(data:FaultyDataSource):Int {
        if (shouldThrow) {
            throw "Transform error";
        }
        return data.data;
    }
}