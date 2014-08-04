package utilities 
{
	/**
	 * ...
	 * @author Ruairi Dorrity
	 */
	public class MessageListener 
	{
		private var _message:String;
		private var _source:*;
		private var _callback:Function;
		private var _messageLimit:int;
		
		public function MessageListener(pMessage:String, pSource:*, pCallback:Function, pMessageLimit:int = -1) 
		{
			init(pMessage, pSource, pCallback, pMessageLimit);
		}
		
		public function init(pMessage:String, pSource:*, pCallback:Function, pMessageLimit:int = -1):void
		{
			_message = pMessage;
			_source = pSource;
			_callback = pCallback;
			_messageLimit = pMessageLimit;
		}
		
		public function get message():String 
		{
			return _message;
		}
		
		public function get source():*
		{
			return _source;
		}
		
		public function get callback():Function
		{
			return _callback;
		}
		
		public function set messageLimit(val:int):void
		{
			_messageLimit = val;
		}
		
		public function get messageLimit():int
		{
			return _messageLimit;
		}
		
		public function destroy():void
		{
			ObjectPool.addToPool(this);
		}
		
	}

}