package com.mikechambers.sgf.gestures
{
	import com.mikechambers.sgf.utils.MathUtil;
	import com.mikechambers.sgf.gestures.events.GestureEvent;
	
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
		
		private var _distanceThreshhold:Number = 20;
		private var _angleThreashhold:Number = .2;
		
		public function GestureManager(target:InteractiveObject = null)
		{
			this.target = target;
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
			
			if(dist < _distanceThreshhold)
			{
				return;
			}
			
			var angle:Number = MathUtil.getAngleBetweenPoints(_startPoint, tempPoint);
			
			var out:GestureEvent;
			if(angle > 0 - _angleThreashhold && 
						angle < _angleThreashhold)
			{
				out = new GestureEvent(GestureEvent.SWIPE_LEFT);
				dispatchEvent(out);
				trace("drag left");
			}
			else if(angle > Math.PI - _angleThreashhold && 
					angle > (Math.PI * -1) + _angleThreashhold)//convert 6.1
			{
				out = new GestureEvent(GestureEvent.SWIPE_RIGHT);
				dispatchEvent(out);
				
				trace("drag right");	
			}
			else if(angle < 1.5 + _angleThreashhold &&
				angle > 1.5 - _angleThreashhold)
			{
				out = new GestureEvent(GestureEvent.SWIPE_UP);
				dispatchEvent(out);
				
				trace("drag up");
			}
			else if(angle < -1.5 + _angleThreashhold &&
				angle > -1.5 - _angleThreashhold)
			{
				out = new GestureEvent(GestureEvent.SWIPE_DOWN);
				dispatchEvent(out);
				
				trace("drag down");
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