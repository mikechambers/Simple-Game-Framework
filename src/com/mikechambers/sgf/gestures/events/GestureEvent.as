package com.mikechambers.sgf.gestures.events
{
	import flash.events.Event;
	
	public class GestureEvent extends Event
	{
		public static const SWIPE_LEFT:String = "onSwipeLeft";
		public static const SWIPE_RIGHT:String = "onSwipeRight";
		public static const SWIPE_UP:String = "onSwipeUp";
		public static const SWIPE_DOWN:String = "onSwipeDown";
		
		public function GestureEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}