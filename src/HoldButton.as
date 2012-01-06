package
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import qnx.ui.buttons.Button;
	
	public class HoldButton extends Button
	{
		public static var MOUSE_CLICK_HOLD:String = "hold_";
		public static var MOUSE_CLICK_SHORT:String = "short_";
		
		private var settings:displayStyle = new displayStyle();
		private var click_timer:Timer;
		private var holdListenCount:Number = 0;
		public var isDown:Boolean = false;
		
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			if(type == MOUSE_CLICK_HOLD)
			{
				holdListenCount++;
			}
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function HoldButton()
		{
			super();
			click_timer = new Timer(settings.longPressTime);
			click_timer.addEventListener(TimerEvent.TIMER, timerFunc);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, click_down);
			this.addEventListener(MouseEvent.MOUSE_UP, click_up);	
		}
		
		private function click_down(event:MouseEvent):void
		{
			isDown = true;
			click_timer.reset();
			click_timer.start();
		}
		
		private function click_up(event:MouseEvent):void
		{
			if(isDown)
			{
				isDown = false;
				if(click_timer.running)
				{
					
					click_timer.stop();
					super.dispatchEvent(new MouseEvent(MOUSE_CLICK_SHORT));
					return;
				}
				else if( this.holdListenCount == 0)
				{
					super.dispatchEvent(new MouseEvent(MOUSE_CLICK_SHORT));
					return;
				}
			}
		}
		
		private function timerFunc(event:TimerEvent):void
		{
			if(isDown && holdListenCount > 0) // sanity check more than anything
			{
				isDown = false;
				click_timer.stop();
				super.dispatchEvent(new MouseEvent(MOUSE_CLICK_HOLD));
			}
		}

	}
	
	
}