package systemsrx.scheduling; #if (concurrent || sys) import rx.Observable;

import rx.Subject; // Используем базовый Subject, как в тестах
import rx.disposables.CompositeDisposable;
import rx.disposables.SingleAssignmentDisposable;
import haxe.Timer; #end

/** 
 * * Default implementation of IUpdateScheduler using Haxe Timer and RxHaxe. 
 * * Provides millisecond level accuracy, but platform-specific implementations 
 * * can offer higher precision. 
**/
class DefaultUpdateScheduler implements IUpdateScheduler {
	#if (concurrent || sys)
	var timer:haxe.Timer;
	var previousTimeMs:Float;
	// Используем базовый Subject из RxHaxe, как в тестах
	var onPreUpdateSubject:Subject<ElapsedTime>;
	var onUpdateSubject:Subject<ElapsedTime>;
	var onPostUpdateSubject:Subject<ElapsedTime>;
	// Используем CompositeDisposable для управления ресурсами, как в тестах
	var disposables:CompositeDisposable;

	public var elapsedTime(default, null):ElapsedTime; // Свойства возвращают Observable, как и должно быть
	public var onPreUpdate(get, null):Observable<ElapsedTime>;
	public var onUpdate(get, null):Observable<ElapsedTime>;
	public var onPostUpdate(get, null):Observable<ElapsedTime>;

	/** * Creates a new DefaultUpdateScheduler. 
	 * * @param updateFrequencyPerSecond The desired update frequency in Hz (updates per second). 
	**/
	public function new(updateFrequencyPerSecond:Int = 60) {
		// Инициализируем CompositeDisposable для управления подписками
		disposables = new CompositeDisposable.create([] );
		// Создаем Subject'ы для событий, используя фабричные методы, как в тестах
		onPreUpdateSubject = Subject.create();
		onUpdateSubject = Subject.create();
		onPostUpdateSubject = Subject.create();
		// Инициализируем время
		previousTimeMs = Timer.stamp() * 1000;
		// Timer.stamp() возвращает секунды
		elapsedTime = new ElapsedTime(0, 0);
		// Создаем и запускаем таймер
		var intervalMs = Math.floor(1000.0 / updateFrequencyPerSecond);
		timer = new Timer(intervalMs);
		// Сохраняем подписку на таймер, чтобы её можно было отменить
		var timerSubscription = SingleAssignmentDisposable.create();
		timerSubscription.set(Subscription.create(() -> timer.run = null));
		// Заглушка
		disposables.add(timerSubscription);
		timer.run = updateTick;
	}

	function get_onPreUpdate():Observable<ElapsedTime> {
		return onPreUpdateSubject;
	}

	function get_onUpdate():Observable<ElapsedTime> {
		return onUpdateSubject;
	}

	function get_onPostUpdate():Observable<ElapsedTime> {
		return onPostUpdateSubject;
	}

	function updateTick():Void {
		var currentTimeMs = Timer.stamp() * 1000;
		var deltaTimeMs = currentTimeMs - previousTimeMs;
		var totalTimeMs = elapsedTime.totalTime + deltaTimeMs;
		// Обновляем elapsedTime
		elapsedTime = new ElapsedTime(deltaTimeMs, totalTimeMs); // Уведомляем подписчиков
		// Согласно оригинальному коду, все три события отправляют одно и то же значение ElapsedTime
		// В RxHaxe у Subject может не быть hasObservers(), поэтому просто отправляем
		onPreUpdateSubject.on_next(elapsedTime);
		onUpdateSubject.on_next(elapsedTime);
		onPostUpdateSubject.on_next(elapsedTime);
		// Обновляем время предыдущего тика
		previousTimeMs = currentTimeMs;
	}

	public function dispose():Void {
		// Отписываемся от всех ресурсов
		if (disposables != null) {
			disposables.unsubscribe();
			disposables = null;
		}
		if (timer != null) {
			timer.stop();
			timer = null;
		}
		// Явно завершаем Subject'ы
		if (onPreUpdateSubject != null) {
			onPreUpdateSubject.on_completed();
			onPreUpdateSubject = null;
		}
		if (onUpdateSubject != null) {
			onUpdateSubject.on_completed();
			onUpdateSubject = null;
		}
		if (onPostUpdateSubject != null) {
			onPostUpdateSubject.on_completed();
			onPostUpdateSubject = null;
		}
	}
	#else
	// Заглушка для платформ без поддержки таймеров/потоков
	public var elapsedTime(default, null):ElapsedTime = new ElapsedTime(0, 0);

	public function new(updateFrequencyPerSecond:Int = 60) {}

	public function dispose():Void {}

	// Возвращаем пустые Observables или null на платформах без поддержки
	public var onPreUpdate(get, null):Observable<ElapsedTime>;
	public var onUpdate(get, null):Observable<ElapsedTime>;
	public var onPostUpdate(get, null):Observable<ElapsedTime>;

	function get_onPreUpdate():Observable<ElapsedTime> {
		// Возвращаем "никогда не производящий элементов" Observable
		return Observable.empty();
		// Или null
	}

	function get_onUpdate():Observable<ElapsedTime> {
		return Observable.empty();
	}

	function get_onPostUpdate():Observable<ElapsedTime> {
		return Observable.empty();
	}
	#end
}