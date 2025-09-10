package systemsrx.events; 
// Предполагаем, что RxHaxe предоставляет Observable 
// Возможно, потребуется адаптация в зависимости от конкретной библиотеки RxHaxe 
import rx.Observable; 
// import rx.subjects.Subject; // Если нужен Subject
 interface IEventSystem { 
    /** 
     * * This method will publish a message synchronously for any listeners to action 
     * */ 
     function publish<T>(message:T):Void; 
     
     /** 
      * * This method will publish a message asynchronously to any listeners 
      * */ 
      function publishAsync<T>(message:T):Void; // В Haxe может быть просто publish, если используем асинхронные потоки Rx 
      
      /** 
       * * Listens out for any messages of a given type to be published 
       * */ 
       function receive<T>():Observable<T>; 
    }