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
	
	public class GestureManager extends EventDispatcher
	{
		private var _target:InteractiveObject;
		//private var _mouseDown:Boolean = false;
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
		private var _angleThreashhold:Number;
		
		public function GestureManager(target:InteractiveObject = null, 
									   distanceThreshold:Number = 20, 
									   angleThreshold:Number = .39)
		{
			this.distanceThreshold = distanceThreshold;
			this.angleThreashhold = angleThreshold;
			this.target = target;
		}
		 
		public function get angleThreashhold():Number
		{
			return _angleThreashhold;
		}

		public function set angleThreashhold(value:Number):void
		{
			_angleThreashhold = value;
		}

		public function get distanceThreshold():Number
		{
			return _distanceThreshold;
		}

		public function set distanceThreshold(value:Number):void
		{
			_distanceThreshold = value;
		}

		public function get target():InteractiveObject
		{
			return _target;
		}

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
		
		var tempPoint:Point = new Point();
		private function onEnterFrame(e:Event):void
		{
			tempPoint.x = _target.mouseX;
			tempPoint.y = _target.mouseY;
			
			
			var dist:Number = MathUtil.distanceBetweenPoints(_startPoint, tempPoint);
			
			if(dist < _distanceThreshold)
			{
				return;
			}
			
			var angle:Number = MathUtil.getAngleBetweenPoints(_startPoint, tempPoint);
			
			var out:GestureEvent;
			if(angle > LEFT_ANGLE - _angleThreashhold && 
						angle < LEFT_ANGLE + _angleThreashhold)
			{
				out = new GestureEvent(GestureEvent.SWIPE_LEFT);
				out.swipeAngle = angle;
				dispatchEvent(out);
				trace("drag left");
			}
			else if(angle > RIGHT_ANGLE - _angleThreashhold && 
					angle > (RIGHT_ANGLE * -1) + _angleThreashhold)//convert 6.1
			{
				out = new GestureEvent(GestureEvent.SWIPE_RIGHT);
				out.swipeAngle = angle;
				dispatchEvent(out);
				
				trace("drag right");	
			}
			else if(angle < TOP_ANGLE + _angleThreashhold &&
				angle > TOP_ANGLE - _angleThreashhold)
			{
				out = new GestureEvent(GestureEvent.SWIPE_UP);
				out.swipeAngle = angle;
				dispatchEvent(out);
				
				trace("drag up");
			}
			else if(angle < BOTTOM_ANGLE + _angleThreashhold &&
				angle > BOTTOM_ANGLE - _angleThreashhold)
			{
				out = new GestureEvent(GestureEvent.SWIPE_DOWN);
				out.swipeAngle = angle;
				dispatchEvent(out);
				
				trace("drag down");
			}
			else if(angle > TOP_LEFT_ANGLE - _angleThreashhold &&
					angle < TOP_LEFT_ANGLE + _angleThreashhold)
			{
				out = new GestureEvent(GestureEvent.SWIPE_UP_LEFT);
				out.swipeAngle = angle;
				dispatchEvent(out);				
				trace("top left");
			}
			else if(angle < BOTTOM_LEFT_ANGLE + _angleThreashhold &&
						angle > BOTTOM_LEFT_ANGLE - _angleThreashhold)
			{
				out = new GestureEvent(GestureEvent.SWIPE_DOWN_LEFT);
				out.swipeAngle = angle;
				dispatchEvent(out);	
				trace("bottom left");
			}
			else if(angle > TOP_RIGHT_ANGLE - _angleThreashhold &&
					angle < TOP_RIGHT_ANGLE + _angleThreashhold)
			{
				out = new GestureEvent(GestureEvent.SWIPE_UP_RIGHT);
				out.swipeAngle = angle;
				dispatchEvent(out);				
				trace("top right");
			}
			else if(angle < BOTTOM_RIGHT_ANGLE + _angleThreashhold &&
					angle > BOTTOM_RIGHT_ANGLE - _angleThreashhold)
			{
				out = new GestureEvent(GestureEvent.SWIPE_DOWN_RIGHT);
				out.swipeAngle = angle;
				dispatchEvent(out);
				trace("bottom right");
			}
			
			if(out)
			{
				//we broadcast the event
				//not unregister handlers
				_target.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
	}
}