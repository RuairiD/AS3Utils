package utilities 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Ruairi Dorrity
	 */
	public class MessageCentre 
	{
		private static var messageListeners:Object;
		
		/** Initialise MessageCentre and create the Object which will store MessageListeners.
		 */
		public static function init():void
		{
			messageListeners = new Object();
		}
		
		/** Add a message listener.
         *  
         *  @param message: the message to listen for.
         *  @param source: the object that added the listener.
		 *  @param callback: the function to be invoked with the message data when MessageCentre receives the relevant message.
         *  @param messageLimit: the number of messages the listener should listen for before being removed. A messageLimit of
		 * 		   -1 indicates an infinite limit.
		 * 
		 *  @return the MessageListener created with these arguments. This MessageListener has already been stored in
		 * 			MessageCentre and can usually be ignored.
         */
		public static function addListener(message:String, source:*, callback:Function, messageLimit:int = -1):MessageListener
		{
			if (messageListeners[message] == null)
			{
				messageListeners[message] = new Vector.<MessageListener>();
			}
			
			var messageListener:MessageListener = ObjectPool.createFromClass(MessageListener, [message, source, callback, messageLimit]) as MessageListener;
			messageListeners[message].push(messageListener);
			
			return messageListener;
		}
		
		/** Add a message listener which is removed after one message is received.
         *  
         *  @param message: the message to listen for.
         *  @param source: the object that added the listener.
		 *  @param callback: the function to be invoked with the message data when MessageCentre receives the relevant message.
		 * 
		 *  @return the MessageListener created with these arguments. This MessageListener has already been stored in MessageCentre and can usually be ignored.
         */
		public static function addListenerOnce(message:String, source:*, callback:Function):MessageListener
		{
			return addListener(message, source, callback, 1);
		}
		
		/** Remove a message listener by the arguments passed to it when it was added.
         *  
         *  @param message: the message associated with the listener.
         *  @param source: the object that added the listener.
		 *  @param callback: the function to be invoked with the message data when MessageCentre receives the relevant message.
         */
		
		public static function removeListenerByArgs(message:String, source:*, callback:Function = null):void
		{
			for each (var messageListener:MessageListener in messageListeners[message])
			{
				if (messageListener.source == source && (callback == null || messageListener.callback == callback))
				{
					messageListener.destroy();
					var index:int = messageListeners[message].indexOf(messageListener);
					messageListeners[message].splice(index, 1);
				}
			}
		}
		
		/** Remove a message listener
         *  
         *  @param messageListener: the MessageListener to be removed.
         */
		public static function removeListener(messageListener:MessageListener):void
		{
			var index:int = messageListeners[messageListener.message].indexOf(messageListener);
			messageListeners[messageListener.message].splice(index, 1);
			
			messageListener.destroy();
		}
		
		/** Send a message with data. Any MessageListener listening for this message will be triggered and its callback invoked.
         *  
         *  @param message: the message to be sent.
		 *  @param data: an object containing any additional data to be passed to the callback function(s).
         */
		public static function sendMessage(message:String, data:Object):void
		{
			for each(var messageListener:MessageListener in messageListeners[message])
			{
				messageListener.callback.apply(messageListener.source, [data]);
				if (messageListener.messageLimit > -1)
				{
					messageListener.messageLimit = messageListener.messageLimit - 1;
					if (messageListener.messageLimit == 0)
					{
						removeListener(messageListener);
					}
				}
			}
		}
		
	}

}