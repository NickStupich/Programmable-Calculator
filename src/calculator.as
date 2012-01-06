package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import qnx.ui.core.Container;
	import qnx.ui.text.Label;
	
	[SWF(width="1024", height="600", backgroundColor="#000000", frameRate="30")]
	public class calculator extends Sprite
	{
		private var expressionLabel:Label;
		private var resultLabel:Label;
		private var errorLabel:Label;
		
		private var settings:displayStyle = new displayStyle();	
		public var evaluator:MathEval = new MathEval();
		private var defineView:DefineView;
		
		private var digitButtons:Array = new Array();
		private var button_decimal:CalcButton;
		private var button_0:CalcButton;
		private var button_div:CalcButton;
		private var button_mul:CalcButton;
		private var button_sub:CalcButton;
		private var button_add:CalcButton;
		private var button_comma:CalcButton;
		private var button_back:MainButton;
		private var button_clear:MainButton;
		private var button_solve:MainButton;
		private var button_sin:CalcButton;
		private var button_cos:CalcButton;
		private var button_tan:CalcButton;
		private var button_exp:CalcButton;
		private var button_ans:CalcButton;
		private var button_lb:CalcButton;
		private var button_rb:CalcButton;
		private var button_e:CalcButton;
		private var button_pi:CalcButton;
		private var button_ln:CalcButton;
		private var button_log:CalcButton;
		private var button_fact:CalcButton;
		private var button_custom1:CustomButton;
		private var button_custom2:CustomButton;
		
		public function addToExpression(str:String):void{
			if(defineView.InUse())
				defineView.addToExpression(str);
			else
				expressionLabel.text += str;
		}
		
		private function solveEquation():void{
			if(defineView.InUse())
				return;
			try
			{
				var result:Number = evaluator.eval(expressionLabel.text);
				resultLabel.text = result.toString();
				evaluator.setLastAnswer(result);
				errorLabel.text = "";
			}
			catch(e:Error)
			{
				errorLabel.text = e.message;
			}
		}
		
		private function backSpace():void
		{
			if(defineView.InUse())
			{
				defineView.backSpace();
			}
			else
			{
				var str:String = expressionLabel.text;
				var names:Array = evaluator.getFunctionNames();
				var newString:String = Utilities.backSpace(str, names);
				expressionLabel.text = newString;
			}
		}
		
		public function calculator()
		{			
			addTextFields();
			defineView = new DefineView(this);
			addChild(defineView);
			addButtons();
		}
		
		private function addTextFields():void
		{
			this.graphics.beginFill(0xAAAAAA, 1.0);
			
			//input box	
			expressionLabel = new Label();
			expressionLabel.text = "";
			expressionLabel.x = settings.expressionLabelX;
			expressionLabel.y = settings.expressionLabelY;			
			expressionLabel.width = settings.expressionLabelWidth;
			expressionLabel.height = settings.expressionLabelHeight;
			expressionLabel.format = settings.inputFormat;
			addChild(expressionLabel);
			
			this.graphics.drawRoundRectComplex(expressionLabel.x, expressionLabel.y, expressionLabel.width, expressionLabel.height, settings.boxRadius, settings.boxRadius, settings.boxRadius, settings.boxRadius);
			
			//result box
			resultLabel = new Label();
			resultLabel.text = "";
			resultLabel.x = settings.resultLabelX;
			resultLabel.y = settings.resultLabelY;
			resultLabel.width = settings.resultLabelWidth;
			resultLabel.height = settings.resultLabelHeight;
			resultLabel.format = settings.inputFormat;
			addChild(resultLabel);
			
			this.graphics.drawRoundRectComplex(resultLabel.x, resultLabel.y, resultLabel.width, resultLabel.height, settings.boxRadius, settings.boxRadius, settings.boxRadius, settings.boxRadius);
		
			errorLabel = new Label();
			errorLabel.text = "";
			errorLabel.x = settings.errorLabelX;
			errorLabel.y = settings.errorLabelY;
			errorLabel.width = settings.errorLabelWidth;
			errorLabel.height = settings.errorLabelHeight;
			errorLabel.format = settings.errorFormat;
			errorLabel.multiline = true;
			errorLabel.wordWrap = true;
			addChild(errorLabel);
		
		}
		
		private function addButtons():void
		{	
			var bracketContainer:Container = new Container();
			bracketContainer.x = settings.borderThickness;
			bracketContainer.y = settings.topButtonY;
			bracketContainer.height = (settings.buttonGap + settings.buttonHeight) * 2;
			bracketContainer.width = (settings.buttonGap + settings.buttonWidth)*3;
			
			var trigContainer:Container = new Container();
			trigContainer.x = bracketContainer.x + bracketContainer.width;
			trigContainer.y = bracketContainer.y;
			trigContainer.width = settings.buttonGap + settings.buttonWidth;
			trigContainer.height = (settings.buttonGap + settings.buttonHeight) * 3;
				
			var digitContainer:Container = new Container();
			digitContainer.x = trigContainer.x + trigContainer.width;
			digitContainer.y = trigContainer.y;
			digitContainer.width = settings.digitWidth;
			digitContainer.height = settings.digitHeight;
			
			var mainContainer:Container = new Container();
			mainContainer.x = digitContainer.x + settings.digitWidth;
			mainContainer.y = digitContainer.y;
			mainContainer.width = settings.buttonWidth + settings.buttonGap;
			mainContainer.height = (settings.buttonHeight + settings.buttonGap) * 4;
			
			var customContainer:Container = new Container();
			customContainer.x = bracketContainer.x;
			customContainer.y = bracketContainer.y + bracketContainer.height;
			customContainer.width = (settings.buttonWidth + settings.buttonGap) * 2;
			customContainer.height = (settings.buttonHeight + settings.buttonGap) * 2;
			
			//create digits 1-9
			for(var i:Number=1;i<10;i++)
			{
				var button_:CalcButton = new CalcButton(i.toString(), i.toString(), this, 0);
				button_.x = digitContainer.x + settings.buttonGap/2 + ((i-1)%3) * (settings.buttonWidth + settings.buttonGap);
				button_.y = digitContainer.y + settings.buttonGap/2 + int((9-i)/3) * (settings.buttonHeight + settings.buttonGap);
				digitButtons.push(button_);
				addChild(button_);
			}
			
			//. 
			button_decimal = new CalcButton(".", ".", this, 0);
			button_decimal.x = digitContainer.x + settings.buttonGap/2;
			button_decimal.y = digitContainer.y + settings.buttonGap/2 + (settings.buttonHeight + settings.buttonGap)*3;
			addChild(button_decimal);
			
			//0
			button_0 = new CalcButton("0", "0", this, 0, 2);
			button_0.x = digitContainer.x + settings.buttonGap/2 + (settings.buttonWidth + settings.buttonGap);
			button_0.y = button_decimal.y;
			addChild(button_0);
			
			
			
			//divide
			button_div = new CalcButton("÷", "÷", this, 1);
			button_div.x = digitContainer.x + settings.buttonGap/2 + (settings.buttonWidth + settings.buttonGap) * 3;
			button_div.y = digitContainer.y + settings.buttonGap/2;
			addChild(button_div);
			
			//mul
			button_mul = new CalcButton("*", "*", this, 1);
			button_mul.x = button_div.x;
			button_mul.y = digitContainer.y + settings.buttonGap/2 + (settings.buttonHeight + settings.buttonGap);
			addChild(button_mul);
			
			//sub
			button_sub = new CalcButton("-", "-", this, 1);
			button_sub.x = button_div.x;
			button_sub.y = digitContainer.y + settings.buttonGap/2 + (settings.buttonHeight + settings.buttonGap) * 2;
			addChild(button_sub);
			
			//add
			button_add = new CalcButton("+", "+", this, 1);
			button_add.x = button_div.x;
			button_add.y = digitContainer.y + settings.buttonGap/2 + (settings.buttonHeight + settings.buttonGap)*3;
			addChild(button_add);
			
			//,
			button_comma = new CalcButton(",", ",", this, 2);
			button_comma.x = mainContainer.x + settings.buttonGap/2;
			button_comma.y = mainContainer.y + settings.buttonGap/2;
			addChild(button_comma);
			
			//backspace button
			button_back = new MainButton("Back", function(event:MouseEvent):void{backSpace()}, 1, 11);
			button_back.x = mainContainer.x + settings.buttonGap/2;
			button_back.y = mainContainer.y + settings.buttonGap/2 + (settings.buttonGap + settings.buttonHeight);
			addChild(button_back);
			
			//clear button
			button_clear = new MainButton("C", function(event:MouseEvent):void{expressionLabel.text = "";});
			button_clear.x = mainContainer.x + settings.buttonGap/2;
			button_clear.y = mainContainer.y + settings.buttonGap/2 + (settings.buttonGap + settings.buttonHeight)*2;
			addChild(button_clear);
			
			//solve button
			button_solve = new MainButton("=", function(event:MouseEvent):void{solveEquation()});
			button_solve.x = mainContainer.x + settings.buttonGap/2;
			button_solve.y = mainContainer.y + settings.buttonGap/2 + (settings.buttonGap + settings.buttonHeight)*3;
			addChild(button_solve);
			
			
			
			//sin
			button_sin = new CalcButton("sin", "sin(", this, 2);
			button_sin.x = trigContainer.x + settings.buttonGap/2;
			button_sin.y = trigContainer.y + settings.buttonGap/2;
			addChild(button_sin);
			
			//cos
			button_cos = new CalcButton("cos", "cos(", this, 2);
			button_cos.x = trigContainer.x + settings.buttonGap/2;
			button_cos.y = trigContainer.y + settings.buttonGap/2 + (settings.buttonGap + settings.buttonHeight);
			addChild(button_cos);
			
			//tan
			button_tan = new CalcButton("tan", "tan(", this, 2);
			button_tan.x = trigContainer.x + settings.buttonGap/2;
			button_tan.y = trigContainer.y + settings.buttonGap/2 + (settings.buttonGap + settings.buttonHeight)*2;
			addChild(button_tan);
			
			//^
			button_exp = new CalcButton("^", "^", this, 2);
			button_exp.x = trigContainer.x + settings.buttonGap/2;
			button_exp.y = trigContainer.y + settings.buttonGap/2 + (settings.buttonGap + settings.buttonHeight)*3;
			addChild(button_exp);
			
			//Ans
			button_ans = new CalcButton("Ans", "ans", this, 2);
			button_ans.x = bracketContainer.x;// + settings.buttonGap/2;
			button_ans.y = bracketContainer.y + settings.buttonGap/2;
			addChild(button_ans);
			
			//(
			button_lb = new CalcButton("(", "(", this, 2);
			button_lb.x = bracketContainer.x + settings.buttonGap/2 + (settings.buttonGap + settings.buttonWidth);
			button_lb.y = bracketContainer.y + settings.buttonGap/2;
			addChild(button_lb);
			
			//)
			button_rb = new CalcButton(")", ")", this, 2);
			button_rb.x = bracketContainer.x + settings.buttonGap/2 + (settings.buttonGap + settings.buttonWidth)*2;
			button_rb.y = bracketContainer.y + settings.buttonGap/2;
			addChild(button_rb);
			
			//e
			button_e = new CalcButton("e", "e", this, 2);
			button_e.x = button_ans.x;
			button_e.y = bracketContainer.y + settings.buttonGap/2 + (settings.buttonGap + settings.buttonHeight);
			addChild(button_e);
			
			//pi
			button_pi = new CalcButton("π", "π", this, 2);
			button_pi.x = bracketContainer.x + settings.buttonGap/2 + (settings.buttonGap + settings.buttonWidth);
			button_pi.y = bracketContainer.y + settings.buttonGap/2 + (settings.buttonGap + settings.buttonHeight);
			addChild(button_pi);
			
			//ln
			button_ln = new CalcButton("ln", "ln(", this, 2);
			button_ln.x = bracketContainer.x + settings.buttonGap/2 + (settings.buttonGap + settings.buttonWidth) * 2;
			button_ln.y = bracketContainer.y + settings.buttonGap/2 + (settings.buttonGap + settings.buttonHeight);
			addChild(button_ln);
			
			//log 
			button_log = new CalcButton("log", "log(", this, 2);
			button_log.x = bracketContainer.x + settings.buttonGap/2 + (settings.buttonGap + settings.buttonWidth)*2;
			button_log.y = bracketContainer.y + settings.buttonGap/2 + (settings.buttonGap + settings.buttonHeight)*2;
			addChild(button_log);
			
			//!
			button_fact = new CalcButton("!", "factorial(", this, 2);
			button_fact.x = bracketContainer.x + settings.buttonGap/2 + (settings.buttonGap + settings.buttonWidth)*2;
			button_fact.y = bracketContainer.y + settings.buttonGap/2 + (settings.buttonGap + settings.buttonHeight)*3;
			addChild(button_fact);
			
			//custom1
			button_custom1 = new CustomButton(this);
			button_custom1.x = button_ans.x;
			button_custom1.y = customContainer.y + settings.buttonGap/2;
			addChild(button_custom1);
			
			//custom2
			button_custom2 = new CustomButton(this);
			button_custom2.x = button_ans.x;
			button_custom2.y = customContainer.y + settings.buttonGap/2 + (settings.buttonHeight + settings.buttonGap);
			addChild(button_custom2);
			
		}
	
		public function defineNewFunction(customButton:CustomButton):void
		{
			defineView.DefineNewFunction(customButton);
		}
		
		public function redefineFunction(customButton:CustomButton):void
		{
			defineView.RedefineFunction(customButton);
		}
	
		public function getCustomButtonCount():Number
		{
			var total:Number = 0;
		
			return total;
		}
	}
}