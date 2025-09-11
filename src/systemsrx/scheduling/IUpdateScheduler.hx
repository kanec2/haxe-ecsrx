package systemsrx.scheduling;

#if (concurrent || sys)
import rx.Observable;
#end

/** * Interface for an update scheduler that provides time tracking and update events. */
interface IUpdateScheduler extends ITimeTracker /*implements IDisposable*/ {
	#if (concurrent || sys)
	var onPreUpdate(get, null):Observable<ElapsedTime>;
	var onUpdate(get, null):Observable<ElapsedTime>;
	var onPostUpdate(get, null):Observable<ElapsedTime>;
	#end // В Haxe нет IDisposable, но можно добавить метод dispose
	function dispose():Void;
}