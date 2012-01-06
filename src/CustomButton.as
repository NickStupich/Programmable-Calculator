package
{
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import qnx.ui.text.Label;
	
	public class CustomButton extends HoldButton
	{
		private var label:Label;
		private var subLabel:Label;
		private var value:String;
		private var funcName:String;
		private var parameters:Array;
		private var parentObj:calculator;
		private var calcs:String;
		private var settings:displayStyle = new displayStyle();
		private var isDefined:Boolean;
		
		private static var START_LABEL_MAIN:String = "Undefined";
		private static var START_LABEL_SUB:String = "Click to define";
		
		private static var nextFuncNumber:Number = 0;
		
		public function CustomButton(parent:calculator, width:Number = 2)
		{
			super();
			
			parentObj = parent;
			isDefined = false;
			height = settings.buttonHeight;
			
			label = new Label();
			label.text = START_LABEL_MAIN;
			label.height = settings.buttonHeight * 0.6;
			label.x = 0;
			label.y = 0;
			
			subLabel = new Label();
			subLabel.text = START_LABEL_SUB;
			subLabel.height = settings.buttonHeight * 0.4;
			subLabel.x = 0;
			subLabel.y = label.height;
			
			if(width == 1)
			{
				this.width = settings.buttonWidth;
				label.width = settings.buttonWidth;
				subLabel.width = settings.buttonWidth;
			}
			else
			{
				this.width = settings.buttonWidth + (settings.buttonWidth + settings.buttonGap) * (width - 1);
				label.width = settings.buttonWidth + (settings.buttonWidth + settings.buttonGap) * (width - 1);
				subLabel.width = settings.buttonWidth + (settings.buttonWidth + settings.buttonGap) * (width - 1);
			}
			
			addEventListener(HoldButton.MOUSE_CLICK_HOLD, DoLongClick);
			addEventListener(HoldButton.MOUSE_CLICK_SHORT, DoShortClick);
			
			label.textField.setTextFormat(settings.customFormatMain);
			subLabel.textField.setTextFormat(settings.customFormatSub);
			
			addChild(label);
			addChild(subLabel);
		}
		
		public function addFunction(name_:String, value_:String, params:Array):void
		{
			funcName = name_;
			value = value_;
			parameters = params;
			label.text = name_;
			subLabel.text = "(" + params.join(", ") + ")";
			isDefined = true;
			label.textField.setTextFormat(settings.customFormatMain);
			subLabel.textField.setTextFormat(settings.customFormatSub);
			
			parentObj.evaluator.addFunction(funcName, eval);
		}
		
		public function removeFunction():void
		{
			parentObj.evaluator.removeFunction(funcName);
			funcName = "";
			value = "";
			parameters = null;
			label.text = START_LABEL_MAIN;
			subLabel.text = START_LABEL_SUB;
			isDefined = false;
			label.textField.setTextFormat(settings.customFormatMain);
			subLabel.textField.setTextFormat(settings.customFormatSub);
		}
		
		public function eval(params:Array, extraFunctions:Dictionary = null):Number{
			
			if(params.length != parameters.length)
				throw Error("" + funcName + " takes " + parameters.length.toString() + " arguments");
			
			//build up a dictionary of each parameter, then pass back 
			//to the evaluator with the dictionary of parameters
			if(extraFunctions == null)
				extraFunctions = new Dictionary();
			
			for(var i:Number=0;i<params.length;i++)
			{
				var p:String = params[i];
				var x:Number = parentObj.evaluator.eval(p, extraFunctions);
				extraFunctions[parameters[i]] = x;
			}
			
			var result:Number = parentObj.evaluator.eval(this.value, extraFunctions);
			return result;
		}
		
		public static function getFuncId():Number{
			nextFuncNumber += 1;
			return nextFuncNumber;
		}
		
		public function getFuncName():String
		{
			return funcName;
		}
		
		private function DoShortClick(event:MouseEvent):void
		{
			if(!isDefined)
			{
				parentObj.defineNewFunction(this);
			}
			else if(parameters.length > 0)
			{
				parentObj.addToExpression(funcName + "(");
			}
			else
			{
				parentObj.addToExpression(funcName);
			}
		}
		
		private function DoLongClick(event:MouseEvent):void
		{
			if(!isDefined)
				parentObj.defineNewFunction(this);
			else
				parentObj.redefineFunction(this);
		}

		public function getParameters():Array
		{
			return this.parameters;
		}
		
		public function getValue():String
		{
			return this.value;
		}

	}
}