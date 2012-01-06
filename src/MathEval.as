package
{	
	import flash.utils.Dictionary;
	
	import mx.controls.List;

	public class MathEval
	{
		private var functions:Dictionary;
		private var operators2:Dictionary;
		private var sortedOperators:Array;
		
		private var lastAnswer:Number = Number.NaN;
		
		public function MathEval()
		{
			functions = new Dictionary();
			functions["sin"] = this.sin;
			functions["cos"] = this.cos;
			functions["tan"] = this.tan;
			functions["ans"] = this.ans;
			functions["π"] = this.pi;
			functions["e"] = this.e;
			functions["log"] = this.log;
			functions["ln"] = this.ln;
			functions["factorial"] = this.factorial;
			
			operators2 = new Dictionary();
			operators2["+"] = function(x:Number, y:Number):Number{return x + y;};
			operators2["-"] = function(x:Number, y:Number):Number{return x - y;};
			operators2["*"] = function(x:Number, y:Number):Number{return x * y;};
			operators2["÷"] = function(x:Number, y:Number):Number{ if(y == 0.0) throw Error("Cannot divide by 0"); return x / y;};
			operators2["^"] = function(x:Number, y:Number):Number{return Math.pow(x, y);};
			
			sortedOperators = new Array("+", "-", "*", "÷", "^");
		}
		
		public function eval(s:String, extraFunctions:Dictionary = null):Number
		{
			//operators that take 2 operands. Ex: 1 + 2
			for(var i:Number=0;i<sortedOperators.length;i++)
			{
				var key:String = sortedOperators[i];
				var bracketCount:Number = 0;
				
				for(var j:Number = 0;j<s.length;j++)
				{	
					if(s.charAt(j) == key && bracketCount == 0)
					{
						if(j == 0 && key == "-")
							return -eval(s.substring(j+1), extraFunctions);
						else if(j == 0 || j == s.length-1)
							throw Error("Invalid use of " + key + ": '" + s + "'");
						return operators2[key](eval(s.substring(0, j), extraFunctions), eval(s.substring(j+1), extraFunctions));
					}
					else if(s.charAt(j) == "(")
						bracketCount++;
					else if(s.charAt(j) == ")")
					{
						bracketCount--;
						if(bracketCount < 0)
							throw Error("Brackets do not match in '" + s + "'");
					}
				}
			}
			
			//build up a complete list of all available functions
			var allFunctions:Dictionary;
			if(extraFunctions == null)
			{
				allFunctions = functions;
			}
			else
			{
				allFunctions = new Dictionary();
				for(key in functions)
					allFunctions[key] = functions[key];
				for(key in extraFunctions)
					allFunctions[key] = extraFunctions[key];
				
			}

			//look for functions that work like func(...), or constants
			for(var key2:String in allFunctions)
			{
				if(s.substr(0, key2.length) == key2)
				{
					if(s.length != key2.length && s.charAt(key2.length) != '(')
					{
						throw Error("Unable to parse '" + s + "'");
					}
					//check if the 'function' is just a number
					if(typeof(allFunctions[key2]) == "number")
						return allFunctions[key2];
					
					//get the parameters without the brackets
					var substring:String;
					if (s.charAt(key2.length) == "(")
					{
						if(s.charAt(s.length-1) != ")")
							throw Error("Brackets do not match in '" + s.substring(key2.length, s.length) + "'");
						substring = s.substring(key2.length + 1, s.length - 1);
					}
					else
						substring = s.substring(key2.length);
					
					
					//split the substring by commas
					var parts:Array = new Array();
					var lastStartIndex:Number = 0;
					var bracketCount2:Number = 0;
					for(i = 0;i < substring.length;i++)
					{
						if(substring.charAt(i) == "(")
							bracketCount2++;
						else if (substring.charAt(i) == ")")
							bracketCount2--;
						else if(substring.charAt(i) == ",")
						{
							parts.push(eval(substring.substring(lastStartIndex, i), extraFunctions));
							lastStartIndex = i+1;
						}
					}
					
					if(bracketCount2 > 0)
					{
						throw Error("Brackets do not match in '" + substring + "'");
					}
					
					if(substring.length > lastStartIndex)
						parts.push(eval(substring.substring(lastStartIndex), extraFunctions));
					
					return allFunctions[key2](parts);
				}
			}		
			
			//check for (...) case, return eval(string without brackets)
			if(s.charAt(0) == "(")
				return eval(s.substring(1, s.length-1), extraFunctions);
			
			if(!isNaN(Number(s.charAt(0))))
			{
				//starts with a number, make sure every letter is a number before we try to parse it as a number
				for(var k:Number=1;k<s.length;k++)
				{
					if(isNaN(Number(s.charAt(k))))
					{
						throw Error("Unable to parse '" + s + "'");
					}
				}
			}
			
			//try parsing it as just a number
			try
			{
				var result:Number = Number(s);
				if(!isNaN(result))
					return result;
			}
			catch(e:Error)
			{
				throw Error("Unable to parse '" + s + "'");
			}
			
			throw Error("Unable to parse '" + s + "'");
		}
		
		public function addFunction(name:String, callback:Function):void
		{
			functions[name] = callback;
		}
		
		public function removeFunction(name:String):void
		{
			delete functions[name];
		}
		
		public function getFunctionNames():Array
		{
			var result:Array = new Array();
			for (var key:String in functions)
				result.push(key);
				
			return result;
		}
		
		//built in functions
		public function setLastAnswer(x:Number):void
		{
			this.lastAnswer = x;
		}
	
		private function sin(l:Array):Number
		{
			if(l.length != 1)
				throw Error("sin() takes 1 argument");
			return Math.sin(l[0]);
		}
		
		private function cos(l:Array):Number
		{
			if(l.length != 1)
				throw Error("cos() takes 1 argument");
			return Math.cos(l[0]);
		}
		
		private function tan(l:Array):Number
		{
			if(l.length != 1)
				throw Error("tan() takes 1 argument");
			return Math.tan(l[0]);
		}
		
		private function ans(l:Array):Number
		{
			if(l.length != 0)
				throw Error("Error after 'ans'");
			
			if(isNaN(this.lastAnswer))
				throw Error("Answer not defined");
			
			return this.lastAnswer;
		}
		
		private function pi(l:Array):Number
		{
			if(l.length != 0)
				throw Error("Error after 'π'");
			
			return Math.PI;
		}
		
		private function e(l:Array):Number
		{
			if(l.length != 0)
				throw Error("Error after 'e'");
			
			return Math.E;
		}
	
		private function log(l:Array):Number
		{
			if(l.length != 1)
				throw Error("Log() takes 1 argument");
			else if(l[0] <= 0)
				throw Error("Cannot take Log() of <= 0");
			
			return ln(l) * Math.LOG10E;
		}
		
		private function ln(l:Array):Number
		{
			if(l.length != 1)
				throw Error("Ln() takes 1 argument");
			else if(l[0] <= 0)
				throw Error("Cannot take Ln() of <= 0");
			
			return Math.log(Number(l[0]));
		}
		
		private function factorial(l:Array):Number
		{
			if(l.length != 1)
				throw Error("Factorial() takes 1 argument");
			
			var x:Number = l[0];
			
			if(x < 0)
				throw Error("Factorial only defined for >= 0");
			
			if(Math.round(x) != x)
				throw Error("Factorial() only defined for integers");
			
			var result:Number = 1;
			while(x > 1)
			{
				result *= x;
				x --;
			}
			
			return result;
		}
		
	}
}