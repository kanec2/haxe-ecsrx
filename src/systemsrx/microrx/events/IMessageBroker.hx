package systemsrx.microrx.events; /** * Interface for a message broker that can both publish and receive messages. */ 
interface IMessageBroker extends IMessagePublisher extends IMessageReceiver {

	// Наследует методы publish и receive
}