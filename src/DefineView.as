package
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import qnx.ui.buttons.Button;
	import qnx.ui.core.Container;
	import qnx.ui.text.Label;
	
	public class DefineView extends Container
	{
		private var showTimer:Timer = null;
		private var hideTimer:Timer = null;
		
		private var settings:displayStyle = new displayStyle();
		private var parentObj:calculator = null;
		private var isInUse:Boolean = false;
		private var functionButton:CustomButton = null;
		private var variableButtons:Array = null;
		private var functionLabel:Label;
		
		private var addVariableButton:MainButton = null;
		private var functionName:String = null;
		
		public function DefineView(parentObj_:calculator)
		{
			super();
			
			this.parentObj = parentObj_;
			this.x = 0;
			this.height = settings.customDefinePanelHeight;
			this.width = settings.totalWidth;
			
			this.graphics.beginFill(settings.customDefinePanelColor, 0.9);
			this.graphics.drawRoundRectComplex(this.x, this.y, this.width, this.height, settings.boxRadius, settings.boxRadius, settings.boxRadius, settings.boxRadius);
			this.y = -settings.customDefinePanelHeight;
			
			showTimer = new Timer(settings.animateTimerDelay);
			showTimer.addEventListener(TimerEvent.TIMER, showTimerTick);
			
			hideTimer = new Timer(settings.animateTimerDelay);
			hideTimer.addEventListener(TimerEvent.TIMER, hideTimerTick);
			
			addUI();
		}
		
		private function addUI():void
		{
			var cancelButton:Button = new HoldButton();
			var cancelLabel:Label = new Label();
			cancelLabel.text = "Remove Function";
			cancelLabel.wordWrap = true;
			cancelLabel.multiline = true;
			cancelButton.addChild(cancelLabel);
			cancelButton.height = settings.buttonHeight;
			cancelButton.x = settings.totalWidth - settings.borderThickness - cancelButton.width;
			cancelButton.y = settings.borderThickness;
			cancelLabel.width = cancelButton.width;
			cancelLabel.height = cancelButton.height;
			cancelLabel.textField.setTextFormat(settings.cancelSaveFormat);
			cancelButton.addEventListener(HoldButton.MOUSE_CLICK_SHORT, cancelButton_CLICK);
			addChild(cancelButton);
			
			var submitButton:Button = new HoldButton();
			var submitLabel:Label = new Label();
			submitLabel.text = "Save Function";
			submitButton.addChild(submitLabel);
			submitButton.height = settings.buttonHeight;
			submitButton.x = settings.totalWidth - settings.borderThickness - submitButton.width;
			submitButton.y = cancelButton.y + cancelButton.height + settings.buttonGap;
			submitLabel.width = submitButton.width;
			submitLabel.height = submitButton.height;
			submitLabel.wordWrap = true;
			submitLabel.multiline = true;
			submitLabel.textField.setTextFormat(settings.cancelSaveFormat);
			submitButton.addEventListener(HoldButton.MOUSE_CLICK_SHORT, submitButton_CLICK);
			addChild(submitButton);
			
			functionLabel = new Label();
			functionLabel.text = "";
			functionLabel.x = settings.borderThickness;
			functionLabel.y = settings.borderThickness;
			functionLabel.width = settings.totalWidth - cancelButton.width - settings.buttonGap - settings.borderThickness * 2;
			functionLabel.height = settings.expressionLabelHeight;
			functionLabel.format = settings.inputFormat;
			addChild(functionLabel);
			
			this.graphics.beginFill(0xAAAAAA, 1.0);
			this.graphics.drawRoundRectComplex(functionLabel.x, functionLabel.y, functionLabel.width, functionLabel.height, settings.boxRadius, settings.boxRadius, settings.boxRadius, settings.boxRadius);
		
			addVariableButton = new MainButton("Add Variable", function(event:MouseEvent):void{addVariable()}, 2, 11);
			addVariableButton.x = settings.borderThickness;
			addVariableButton.y = functionLabel.y + functionLabel.height + settings.buttonGap;
			addChild(addVariableButton);
		}
		
		public function addVariable(name:String = null):void
		{
			if(null == name)
			{
				var currentButtonCount:Number = parentObj.getCustomButtonCount();
				if(currentButtonCount == 0)
					name = "X" + (variableButtons.length + 1).toString();
				else if(currentButtonCount == 1)
					name = "Y" + (variableButtons.length + 1).toString();
				else
					name = "Z" + (variableButtons.length + 1).toString();
			}
			
			var button:CalcButton = new CalcButton(name, name, this.parentObj, 4, 1);
			button.y = addVariableButton.y;
			button.x = addVariableButton.x + addVariableButton.width + settings.buttonGap + (settings.buttonWidth + settings.buttonGap) * variableButtons.length;
			variableButtons.push(button);
			addChild(button);
			
			if(variableButtons.length >= 5)
			{
				addVariableButton.enabled = false;
				addVariableButton.setTextColor(0x888888);
			}
		}
		
		public function DefineNewFunction(button:CustomButton):void
		{
			functionButton = button;
			variableButtons = new Array();
			
			var funcId:Number = CustomButton.getFuncId();
			functionName = "func" + funcId.toString();
			this.show();
		}
		
		public function RedefineFunction(button:CustomButton):void
		{
			functionButton = button;
			
			//update the UI according to the variables and then function text
			functionLabel.text = button.getValue();
			functionName = button.getFuncName();
			
			for each(var param:String in button.getParameters())
			{
				addVariable(param);
			}
			
			this.show();
		}
		
		private function show():void
		{
			if(variableButtons.length < 5)
				addVariableButton.enabled = true;
			else
				addVariableButton.enabled = false;
			
			isInUse = true;
			showTimer.reset();
			showTimer.start();
		}
		
		private function hide():void
		{
			isInUse = false;
			hideTimer.reset();
			hideTimer.start();
		}
		
		private function showTimerTick(event:TimerEvent):void
		{
			this.y += settings.animateMovement;
			if(this.y > 0)
			{
				this.y = 0;
				showTimer.stop();
			}
		}
		
		private function hideTimerTick(event:TimerEvent):void
		{
			this.y -= settings.animateMovement;
			if(this.y < -this.height)
			{
				this.y = -this.height;
				hideTimer.stop();
				removeVariables();
			}
		}

		private function setFunction():void
		{
			var orderedParameters:Array = new Array();
			for each(var button:CalcButton in variableButtons)
			{
				orderedParameters.push(button.getName());
			}
			
			var expression:String = functionLabel.text;
			functionButton.addFunction(functionName, expression, orderedParameters);
		}
		
		private function deleteFunction():void
		{
			functionButton.removeFunction();
		}
		
		private function removeVariables():void
		{
			var orderedParameters:Array = new Array();
			//get rid of all the variable buttons
			while(variableButtons.length > 0)
			{
				var button:CalcButton = variableButtons.shift(); //like pop() but from start
				removeChild(button);
			}
			
			functionLabel.text = "";
			
			addVariableButton.enabled = true;
			addVariableButton.setTextColor(0x000000);
		}
	
		private function cancelButton_CLICK(event:MouseEvent):void
		{
			deleteFunction();
			this.hide();
		}
		
		private function submitButton_CLICK(event:MouseEvent):void
		{
			setFunction();
			this.hide();
		}
		
		public function InUse():Boolean
		{
			return this.isInUse;
		}
		
		public function addToExpression(str:String):void
		{
			this.functionLabel.text += str;
		}
		
		public function getText():String
		{ 
			return this.functionLabel.text;
		}
		
		public function setText(s:String):void
		{
			this.functionLabel.text = s;
		}

		public function backSpace():void
		{
			var str:String = functionLabel.text;
			var names:Array = parentObj.evaluator.getFunctionNames();
			
			for each(var button:CalcButton in variableButtons)
			{
				names.push(button.getName());
			}
			
			var newString:String = Utilities.backSpace(str, names);
			functionLabel.text = newString;
		}
	}
}