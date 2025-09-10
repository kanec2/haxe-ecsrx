package systemsrx.microrx.events; /** * Interface for a message broker that can both publish and receive messages in Haxe. */ interface IMessageBrokerHx extends IMessagePublisher extends IMessageReceiverHx {

	// Наследует методы publish и receive с явной передачей типа
}