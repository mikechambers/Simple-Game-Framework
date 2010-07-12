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
	public class ObjectPool
	{
		private var pools:Dictionary;
		private static var instance:ObjectPool;
		public function ObjectPool()
		{
			pools = new Dictionary();
		}
		
		public static function getInstance():ObjectPool
		{
			if(!instance)
			{
				instance = new ObjectPool();
			}
			
			return instance;
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
		
		public function getObject(classType:Class):Object
		{
			var go:Object;
			
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
			
			for each(var g:Object in pool)
			{
				if(g == go)
				{
					hasObject = true;
					break;
				}
			}
			
			if(hasObject)
			{
				pool.push(go);
			}			
		}		
		
		
	}
}