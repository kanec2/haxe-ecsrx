package systemsrx.microrx.events; #if (concurrent || sys) import rx.Observable; #end /** * Interface for receiving messages. */ interface IMessageReceiver {/** * Subscribe to messages of a specific type. * @return An observable sequence of messages of type T. */ function receive<T>():Observable<T>;

}