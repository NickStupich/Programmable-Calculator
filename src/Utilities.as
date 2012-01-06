package
{
	public class Utilities
	{
		public function Utilities()
		{	
		}
		
		public static function backSpace(str:String, funcNames:Array):String
		{
			var lengthToRemove:Number = 1;
			
			for each (var funcName:String in funcNames)
			{
				if(str.substr(str.length-funcName.length) == funcName)
				{
					lengthToRemove = funcName.length;
					break;
				}
				
				if(str.substr(str.length-funcName.length-1) == (funcName + "("))
				{
					lengthToRemove = funcName.length + 1;
					break;
				}
			}
			
			var result:String = str.substring(0, str.length - lengthToRemove);
			
			return result;
		}
	}
}