package systemsrx.microrx.events; /** * Interface for publishing messages. */ interface IMessagePublisher {/** * Send Message to all receivers. * @param message The message to publish. */ function publish<T>(message:T):Void;

}