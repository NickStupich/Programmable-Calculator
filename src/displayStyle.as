package
{
	import flash.text.TextFormat;
	
	import mx.controls.Text;
	
	public class displayStyle
	{
		public var totalWidth:Number = 1024;
		public var totalHeight:Number = 600;
		public var borderThickness:Number = 20;
		
		public var buttonGap:Number = 10;
		public var buttonWidth:Number = 100;
		public var buttonHeight:Number = (totalHeight - buttonGap * 5 - borderThickness * 2) / 6;
		
		public var topButtonY:Number = buttonGap * 2 + buttonHeight * 2 + borderThickness;
		
		public var digitWidth:Number = (buttonWidth + buttonGap) * 4;
		public var digitHeight:Number = (buttonHeight + buttonGap) * 3;
		
		public var expressionLabelX:Number = borderThickness;
		public var expressionLabelY:Number = borderThickness;
		public var expressionLabelWidth:Number = totalWidth - 2 * expressionLabelX;
		public var expressionLabelHeight:Number = buttonHeight;
		
		public var resultLabelY:Number = expressionLabelY + expressionLabelHeight + buttonGap;
		public var resultLabelX:Number = 500;
		public var resultLabelHeight:Number = expressionLabelHeight;
		public var resultLabelWidth:Number = totalWidth - resultLabelX - borderThickness;
		
		public var errorLabelX:Number = borderThickness ;
		public var errorLabelY:Number = resultLabelY;
		public var errorLabelHeight:Number = resultLabelHeight;
		public var errorLabelWidth:Number = resultLabelX - errorLabelX;
		
		public var boxRadius:Number = 5;
		
		public var textFormat:TextFormat;
		public var smallerTextFormat:TextFormat;
		public var inputFormat:TextFormat;
		public var resultFormat:TextFormat;
		public var customFormatMain:TextFormat;
		public var customFormatSub:TextFormat;
		public var errorFormat:TextFormat;
		public var cancelSaveFormat:TextFormat;
		
		public var animateTimerDelay:Number = 30;
		public var animateMovement:Number = 20;
		public var customDefinePanelHeight:Number = buttonHeight * 2 + buttonGap * 2 + borderThickness;
		public var customDefinePanelColor:uint = 0x004099;
		
		public var longPressTime:Number = 1000;
		
		public function displayStyle()
		{
			textFormat = new TextFormat();
			textFormat.size = 50;    
			textFormat.align = "center";
			
			smallerTextFormat = new TextFormat();
			smallerTextFormat.size = 30;
			smallerTextFormat.align = "center";
			
			inputFormat = new TextFormat();
			inputFormat.size = 35;
			inputFormat.color = 0x000000;
			inputFormat.align = "right";
			
			resultFormat = new TextFormat();
			resultFormat.size = 40;
			resultFormat.color = 0x000000;
			resultFormat.align = "right";
			
			customFormatMain = new TextFormat();
			customFormatMain.size = 35;
			customFormatMain.color = 0x000000;
			customFormatMain.align = "center";
			
			customFormatSub = new TextFormat();
			customFormatSub.size = 20;
			customFormatSub.color = 0x000000;
			customFormatSub.align = "center";
			
			errorFormat = new TextFormat();
			errorFormat.size = 20;
			errorFormat.color = 0xFF0000;
			errorFormat.align = "center";
			
			cancelSaveFormat = new TextFormat();
			cancelSaveFormat.size = 30;
			cancelSaveFormat.color = 0x000000;
			cancelSaveFormat.align = "center";
		}
	}
}