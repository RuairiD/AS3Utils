package  
{
	import utilities.ObjectPool;
	/**
	 * ...
	 * @author Ruairi Dorrity
	 */
	public class PoolableClass 
	{
		private var foo:String;
		private var bar:int;
		
		public function PoolableClass(f:String, b:int) 
		{
			init(f, b);
		}
		
		public function init(f:String, b:int):void
		{
			foo = f;
			bar = b;
		}
		
		public function destroy():void
		{
			ObjectPool.addToPool(this);
		}
		
	}

}