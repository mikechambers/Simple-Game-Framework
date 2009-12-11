/*
The MIT License

Copyright (c) 2009 Mike Chambers

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package com.mikechambers.sgf.gestures.events
{
	import flash.events.Event;
	
	public class GestureEvent extends Event
	{
		
		/**
		 * Indicates a swipe to the left. 
		 */		
		public static const SWIPE_LEFT:String = "SWIPE_LEFT";
		
		/**
		 * Indicates a swipe to the right. 
		 */			
		public static const SWIPE_RIGHT:String = "SWIPE_RIGHT";
		
		/**
		 * Indicates a swipe up. 
		 */			
		public static const SWIPE_UP:String = "SWIPE_UP";
		
		/**
		 * Indicates a swipe down. 
		 */			
		public static const SWIPE_DOWN:String = "SWIPE_DOWN";
		
		/**
		 * Indicates a swipe to the bottom right. 
		 */			
		public static const SWIPE_DOWN_RIGHT:String = "SWIPE_DOWN_RIGHT";
		
		/**
		 * Indicates a swipe to the bottom left. 
		 */			
		public static const SWIPE_DOWN_LEFT:String = "SWIPE_DOWN_LEFT";
		
		/**
		 * Indicates a swipe to the top right. 
		 */			
		public static const SWIPE_UP_RIGHT:String = "SWIPE_UP_RIGHT";
		
		/**
		 * Indicates a swipe to the top left. 
		 */			
		public static const SWIPE_UP_LEFT:String = "SWIPE_UP_LEFT";		
		
		/**
		 * The exact angle in radians of the swipe. 
		 */		
		public var swipeAngle:Number;
		
		public function GestureEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}