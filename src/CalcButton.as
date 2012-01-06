package
{
	import flash.events.MouseEvent;
	
	import qnx.ui.text.Label;
	
	public class CalcButton extends HoldButton
	{
		private var label:Label;
		private var value:String;
		public var parentObj:calculator;
		private var settings:displayStyle = new displayStyle();
		
		public function CalcButton(name:String, value_:String, parent:calculator, style:Number, width:Number = 1)
		{
			super();
			
			label = new Label();
			label.text = name;
			label.height = settings.buttonHeight;

			value = value_;
			this.height = settings.buttonHeight;
			
			if(width == 1)
			{
				label.width = settings.buttonWidth;
				this.width = settings.buttonWidth;
			}
			else
			{
				this.width = settings.buttonWidth + (settings.buttonWidth + settings.buttonGap) * (width-1);				
				label.width = settings.buttonWidth + (settings.buttonWidth + settings.buttonGap) * (width-1);
			}
			
			parentObj = parent;
			
			this.addEventListener(HoldButton.MOUSE_CLICK_SHORT, mouseClick);
			
			label.textField.setTextFormat(settings.textFormat);
			
			addChild(label);
			
		}
		
		public function mouseClick(event:MouseEvent):void{
			parentObj.addToExpression(this.value);
		}
	
		public function getName():String{
			return this.value;
		}
	}
}