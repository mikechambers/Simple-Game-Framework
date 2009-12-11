package com.mikechambers.sgf.gestures.events
{
	import flash.events.Event;
	
	public class GestureEvent extends Event
	{
		public static const SWIPE_LEFT:String = "SWIPE_LEFT";
		public static const SWIPE_RIGHT:String = "SWIPE_RIGHT";
		public static const SWIPE_UP:String = "SWIPE_UP";
		public static const SWIPE_DOWN:String = "SWIPE_DOWN";
		
		public static const SWIPE_DOWN_RIGHT:String = "SWIPE_DOWN_RIGHT";
		public static const SWIPE_DOWN_LEFT:String = "SWIPE_DOWN_LEFT";
		public static const SWIPE_UP_RIGHT:String = "SWIPE_UP_RIGHT";
		public static const SWIPE_UP_LEFT:String = "SWIPE_UP_LEFT";		
		
		public var swipeAngle:Number;
		
		public function GestureEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}