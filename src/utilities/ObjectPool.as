package utilities 
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Ruairi Dorrity
	 */
	public class ObjectPool 
	{
		private static var pool:Dictionary;
		
		/** Initialise ObjectPool and create the pool to stored Objects.
		 */
		public static function init():void
		{
			pool = new Dictionary();
		}
		
		/** Create an instance of a Class using the qualified class name.
         *  
         *  @param className: the qualified class name of the Class of which an instance should be created.
		 *  @param args: an Array of args to be passed to the constructor.
		 * 
		 *  @return a fresh instance of className's Class.
         */
		public static function createFromString(className:String, args:Array = null):Object
		{
			return createFromClass(getClass(className), args);
		}
		
		/** Create an instance of a Class, recycling an object from the pool if one is available.
         *  
         *  @param objectClass: the Class of which an instance should be created.
		 *  @param args: an Array of args to be passed to the constructor.
		 * 
		 *  @return a fresh instance of objectClass.
         */
		public static function createFromClass(objectClass:Class, args:Array = null):Object
		{
			if (args == null)
			{
				args = new Array();
			}
			var result:Object;
			if (pool[objectClass] && pool[objectClass].length > 0)
			{
				result = pool[objectClass].pop();
				result.init.apply(null, args);
			}
			
			if (result == null)
			{
				result = createInstance(objectClass, args);
			}
			
			return result;
		}
		
		/** Add an object which is no longer in use to the pool.
         *  
         *  @param object: the object to be pooled.
         */
		public static function addToPool(object:*):void
		{
			var objectClass:Class = Object(object).constructor;
			if (!pool[objectClass])
			{
				pool[objectClass] = new Array();
			}
			
			pool[objectClass].push(object);
		}
		
		/** Call the constructor of a class with arguments.
         *  
         *  @param instanceClass: the Class to create an of.
		 *  @param args: an Array of arguments to be applied to the constructor.
		 * 
		 *  @return the instance of instanceClass.
		 * 
		 *  N.B. the code for this function is pretty ugly; this is because I haven't found a way to invoke a constructor
		 *  with an Array of arguments (apply can be used on Functions, but not constructors). I will rewrite this function
		 *  if and when I find a better solution.
         */
		public static function createInstance(instanceClass:Class, args:Array):Object
		{
			var instance:Object;
			switch(args.length)
			{
				case 0:
					instance = new instanceClass();
					break;
				case 1:
					instance = new instanceClass(args[0]);
					break;
				case 2:
					instance = new instanceClass(args[0], args[1]);
					break;
				case 3:
					instance = new instanceClass(args[0], args[1], args[2]);
					break;
				case 4:
					instance = new instanceClass(args[0], args[1], args[2], args[3]);
					break;
				case 5:
					instance = new instanceClass(args[0], args[1], args[2], args[3], args[4]);
					break;
				case 6:
					instance = new instanceClass(args[0], args[1], args[2], args[3], args[4], args[5]);
					break;
				case 7:
					instance = new instanceClass(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
					break;
				case 8:
					instance = new instanceClass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
					break;
				case 9:
					instance = new instanceClass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
					break;
				case 10:
					instance = new instanceClass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
					break;
				default:
					throw new ArgumentError("Too many arguments (" + args.length + ") to create instance.");
					break;
			}
			return instance;
		}
		
		/** Get a Class from its full qualified name.
         *  
         *  @param className: the qualified class name of a Class
		 *         e.g. "flash.display::Sprite".
         */
		public static function getClass(className:String):Class
		{
			var instanceClass:Class = getDefinitionByName(className) as Class;
			return instanceClass;
		}
		
	}

}