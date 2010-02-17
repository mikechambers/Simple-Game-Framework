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

package com.mikechambers.sgf.gameobjects
{
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.geom.Point;		
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
		
	import com.mikechambers.sgf.events.TickEvent;
	import com.mikechambers.sgf.time.TickManager;		
		
	import com.mikechambers.sgf.memory.IMemoryManageable;
	import com.mikechambers.sgf.pools.IGameObjectPoolable;		
		
	public class GameObject extends MovieClip implements IMemoryManageable, IGameObjectPoolable
	{
		
		protected var health:Number = 1;
		protected var __target:DisplayObject;
		protected var bounds:Rectangle;
		protected var modifier:Number = 0;
		
		protected var tickManager:TickManager;	
		
		public function GameObject()
		{
			super();		
			
			mouseEnabled = false;
			mouseChildren = false;
			
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
																		true);
																														
			cacheAsBitmap = true;
			cacheAsBitmapMatrix = new Matrix();
		}
		
		public function initialize(bounds:Rectangle, 
										target:DisplayObject = null, 
										modifier:Number = 1):void
		{
			this.bounds = bounds;
			__target = target;
			this.modifier = modifier;		
		}
		
		protected function onStageAdded(e:Event):void
		{
			if(!tickManager)
			{
				tickManager = TickManager.getInstance();
			}
			
			removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			addEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved, false,
																		0, true);
		}
		
		protected function onStageRemoved(e:Event):void
		{
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
																		true);
			removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);																
		}

		protected function onTick(e:TickEvent):void
		{
		}		
		
		public function set target(v:DisplayObject):void
		{
			__target = v;
		}
		
		public function start():void
		{
			tickManager.addEventListener(TickEvent.TICK, onTick, false, 0, true);

		}
		
		public function pause():void
		{
			tickManager.removeEventListener(TickEvent.TICK, onTick);
		}		
		
		protected function generateRandomBoundsPoint():Point
		{
			var p:Point = new Point();
			p.x = Math.random() * bounds.width;
			p.y = Math.random() * bounds.height;
			
			return p;
		}
	
		public function dealloc():void
		{			
			if(tickManager)
			{				
				tickManager.removeEventListener(TickEvent.TICK, onTick);

				tickManager = null;
			}
			
			removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);
		}	
	
	}

}