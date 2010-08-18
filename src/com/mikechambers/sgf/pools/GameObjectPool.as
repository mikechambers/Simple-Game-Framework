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

package com.mikechambers.sgf.pools
{
	
	import com.mikechambers.sgf.gameobjects.GameObject;
	
	import flash.utils.Dictionary;
	
	public class GameObjectPool
	{
		private static var instance:GameObjectPool = null;
						
		private var pools:Dictionary;
		
		public function GameObjectPool()
		{
			super();
			pools = new Dictionary();
		}
		
		private function getPool(classType:Class):Array
		{
			var pool:Array = pools[classType];
			if(!pool)
			{
				pool = new Array();
				pools[classType] = pool;
			}
			
			return pool;
		}
		
		public static function getInstance():GameObjectPool
		{
			if(!instance)
			{
				instance = new GameObjectPool();
			}
			
			return instance;
		}
		
		public function getGameObject(classType:Class):GameObject
		{
			var go:GameObject;
			
			var pool:Array = getPool(classType);
			
			if(pool.length)
			{
				go = pool.pop();
			}
			else
			{
				go = new classType();
			}
			return go;
		}
		
		public function returnGameObject(go:GameObject):void
		{			
			//put this property in game object as a static prop
			var classType:Class = go["constructor"] as Class;
						
			var pool:Array = getPool(classType);
			
			var hasObject:Boolean = false;
			
			for each(var g:GameObject in pool)
			{
				if(g == go)
				{
					hasObject = true;
					break;
				}
			}
			
			if(!hasObject)
			{
				pool.push(go);
			}
				
			go.pause();
			
			//not we might be able to just set the visiblity on this, and keep
			//it cached by the GPU
			go.x = -50;
			go.y = -50;
		}
	}
}

