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

package com.mikechambers.sgf.gestures
{
	import com.mikechambers.sgf.gestures.events.GestureEvent;
	import com.mikechambers.sgf.utils.MathUtil;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/*
	*	Class that watches for input gestures on the specified display object.
	*
	*	Current supports swipe gestures in 8 directions.
	*/
	public class GestureManager extends EventDispatcher
	{
		private var _target:InteractiveObject;

		private var _startPoint:Point = new Point();
		
		private const TOP_ANGLE:Number = 1.57;
		private const RIGHT_ANGLE:Number = 3.14;
		private const BOTTOM_ANGLE:Number = -1.57;
		private const LEFT_ANGLE:Number = 0;
		private const TOP_LEFT_ANGLE:Number = .78;
		private const BOTTOM_LEFT_ANGLE:Number = -.78;
		private const TOP_RIGHT_ANGLE:Number = 2.36;
		private const BOTTOM_RIGHT_ANGLE:Number = -2.36;		
		
		private var _distanceThreshold:Number;
		private var _angleThreashold:Number;
		
		private var _tempPoint:Point = new Point();
		
		
		/**
		 * Constructor 
		 * @param target InteractiveObject which will be watched for gesture input.
		 * @param distanceThreshold The minimum distance a gesture must occur before being
		 * recognized.
		 * @param angleThreshold angle in radians that specifies how much padding 
		 * an angle vector will have when determining a swipe.
		 * 
		 */		
		public function GestureManager(target:InteractiveObject = null, 
									   distanceThreshold:Number = 20, 
									   angleThreshold:Number = .39)
		{
			this.distanceThreshold = distanceThreshold;
			this.angleThreashold = angleThreshold;
			this.target = target;
		}
		 
		/**
		 * 
		 * @return angleThreshold being used to determine swipe range.
		 * 
		 */		
		public function get angleThreashold():Number
		{
			return _angleThreashold;
		}

		/**
		 * 
		 * @param value angle in radians that specifies how much padding 
		 * an angle vector will have when determining a swipe.
		 * 
		 */		
		public function set angleThreashold(value:Number):void
		{
			_angleThreashold = value;
		}

		/**
		 * 
		 * @return The current distance in pixels being used to determine
		 * that a swipe has occured
		 * 
		 */		
		public function get distanceThreshold():Number
		{
			return _distanceThreshold;
		}

		/**
		 * 
		 * @param value The minimum distance in pixels that a swipe must
		 * be before it is recognized as a swipe
		 * 
		 */		
		public function set distanceThreshold(value:Number):void
		{
			_distanceThreshold = value;
		}

		/**
		 * 
		 * @return The InteractiveObject instances on which swipes are being
		 * monitored and detected.
		 * 
		 */		
		public function get target():InteractiveObject
		{
			return _target;
		}

		/**
		 * 
		 * @param value The InteractiveObject instance on which swipes will
		 * be dectected.
		 * 
		 */		
		public function set target(value:InteractiveObject):void
		{
			if(_target)
			{
				_target.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				_target.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				_target.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				_target.removeEventListener(MouseEvent.ROLL_OUT, onMouseUp);
			}
				
			_target = value;
			
			if(_target)
			{
				_target.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				_target.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				_target.addEventListener(MouseEvent.ROLL_OUT, onMouseUp);
			}
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			_target.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			_startPoint.x = e.localX;
			_startPoint.y = e.localY;
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			_target.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{			
			_tempPoint.x = _target.mouseX;
			_tempPoint.y = _target.mouseY;
			
			var dist:Number = MathUtil.distanceBetweenPoints(_startPoint, _tempPoint);
			
			if(dist < _distanceThreshold)
			{
				return;
			}
			
			var angle:Number = MathUtil.getAngleBetweenPoints(_startPoint, _tempPoint);
			
			var out:GestureEvent;
			if(angle > LEFT_ANGLE - _angleThreashold && 
						angle < LEFT_ANGLE + _angleThreashold)
			{
				out = new GestureEvent(GestureEvent.SWIPE_LEFT);
			}
			else if(angle > RIGHT_ANGLE - _angleThreashold && 
					angle > (RIGHT_ANGLE * -1) + _angleThreashold)
			{
				out = new GestureEvent(GestureEvent.SWIPE_RIGHT);
			}
			else if(angle < TOP_ANGLE + _angleThreashold &&
				angle > TOP_ANGLE - _angleThreashold)
			{
				out = new GestureEvent(GestureEvent.SWIPE_UP);
			}
			else if(angle < BOTTOM_ANGLE + _angleThreashold &&
				angle > BOTTOM_ANGLE - _angleThreashold)
			{
				out = new GestureEvent(GestureEvent.SWIPE_DOWN);
			}
			else if(angle > TOP_LEFT_ANGLE - _angleThreashold &&
					angle < TOP_LEFT_ANGLE + _angleThreashold)
			{
				out = new GestureEvent(GestureEvent.SWIPE_UP_LEFT);			
			}
			else if(angle < BOTTOM_LEFT_ANGLE + _angleThreashold &&
						angle > BOTTOM_LEFT_ANGLE - _angleThreashold)
			{
				out = new GestureEvent(GestureEvent.SWIPE_DOWN_LEFT);	
			}
			else if(angle > TOP_RIGHT_ANGLE - _angleThreashold &&
					angle < TOP_RIGHT_ANGLE + _angleThreashold)
			{
				out = new GestureEvent(GestureEvent.SWIPE_UP_RIGHT);		
			}
			else if(angle < BOTTOM_RIGHT_ANGLE + _angleThreashold &&
					angle > BOTTOM_RIGHT_ANGLE - _angleThreashold)
			{
				out = new GestureEvent(GestureEvent.SWIPE_DOWN_RIGHT);
			}
			
			if(out)
			{
				_target.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				
				out.swipeAngle = angle;
				dispatchEvent(out);
			}
		}
		
	}
}