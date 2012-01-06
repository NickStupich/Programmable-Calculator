package
{
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import qnx.ui.text.Label;
	
	public class MainButton extends HoldButton
	{
		private var label:Label;
		private var settings:displayStyle = new displayStyle();
		private var callBackFunction:Function;
		public function MainButton(name:String, callback:Function, width:Number = 1, style:Number = 10)
		{
			super();
			
			label = new Label();
			label.text = name;
			
			if(style == 11)
				label.textField.setTextFormat(settings.smallerTextFormat);	
			else
				label.textField.setTextFormat(settings.textFormat);
			
			label.height = label.textField.textHeight;
			addChild(label);
			
			this.height = settings.buttonHeight;
			
			if(width == 1)
			{
				this.width = settings.buttonWidth;
				label.width = settings.buttonWidth;
			}
			else
			{
				this.width = settings.buttonWidth + (settings.buttonWidth + settings.buttonGap) * (width-1);
				label.width =  settings.buttonWidth + (settings.buttonWidth + settings.buttonGap) * (width-1);
			}
			
			label.y = (this.height - label.height)/2;
			
			this.callBackFunction = callback;
			
			this.addEventListener(MOUSE_CLICK_SHORT, callBackFunction);
		}
		
		public function setTextColor(newColor:uint):void{
			label.textField.textColor = newColor;
		}
	}
}