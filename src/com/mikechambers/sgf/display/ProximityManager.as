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

package com.mikechambers.sgf.display
{

	import flash.geom.Rectangle;
	import __AS3__.vec.Vector;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class ProximityManager
	{
		//Collection of DisplayObjects sorted into a grid
		private var grid:Vector.<Vector.<DisplayObject>>;
		
		//the number of cells in the grid
		private var gridLength:uint;
		
		//number of colums
		private var cols:uint;
		
		//number of rows
		private var rows:uint;
		
		//The dimensions of each individual grid cell
		private var gridSize:Number;
		
		//Result cache for use between calls of getNeighbor (reset in update)
		private var cache:Vector.<Vector.<DisplayObject>>;
		
		//constructor
		public function ProximityManager(gridSize:Number, bounds:Rectangle)
		{
			this.gridSize = gridSize;
			super();
			
			init(gridSize, bounds);
		}
		
		//init function. Move out of constructor so it can be jitted
		private function init(gridSize:Number, bounds:Rectangle):void
		{
			//determine number of rows and colums
			rows = Math.ceil(bounds.height / gridSize);
			cols = Math.ceil(bounds.width / gridSize);
			
			//probably should move this to instance var
			gridLength = rows * cols;
			
			//initialize the grid
			grid = new Vector.<Vector.<DisplayObject>>(gridLength, true);
			
			//could do the lazily
			//pre-populate the grid slots with vectors to hold items.
			//we will re-use these instance through lifetime of class instance
			for(var i:int = 0; i < gridLength; i++)
			{
				grid[i] = new Vector.<DisplayObject>();
			}
			
			//create the cache
			cache = new Vector.<Vector.<DisplayObject>>(gridLength, true);
		}
		
		//write my own function to concatanate Vectors. All built in Vector
		//APIs that could be used result in a new Vector allocation, which I
		//want to avoid (especially for iphone)
		private final function concatVectors(a:Vector.<DisplayObject>, b:Vector.<DisplayObject>):Vector.<DisplayObject>
		{			
			for each(var dobj:DisplayObject in b)
			{
				a.push(dobj);
			}
			
			return a;
		}
		
		public function getNeighbors(dobj:DisplayObject):Vector.<DisplayObject>
		{
			//new Vector to return results
			var out:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			
			//find column and row for the specificed DisplayObject
			var col:uint = uint(dobj.x / gridSize);
			var row:uint = uint(dobj.y / gridSize);			
			
			//find its cell slot
			var gridSlot:uint = cols * row + col;
			
			
			//see if we have already generated the results since update was
			//last called. If so, just return the cached results.
			if(cache[gridSlot] != null)
			{
				return cache[gridSlot];
			}
			
			//start putting together results.
			//first is for slot / cell where the display object is
			concatVectors(out, grid[gridSlot]);
			
			//pre-calculate which cells are available
			var canWest:Boolean = col != 0;
			var canNorth:Boolean = row != 0;
			var canSouth:Boolean = row != rows - 1;
			var canEast:Boolean = col != cols - 1;
						
			//west
			if(canWest)
			{
				concatVectors(out, grid[cols * row + col - 1]);
			}
			
			//north west
			if(canNorth && canWest)
			{
				concatVectors(out, grid[cols * (row - 1) + col - 1]);
			}
			
			//north
			if(canNorth)
			{
				concatVectors(out, grid[cols * (row - 1) + col]);
			}
			
			//north east
			if(canNorth && canEast)
			{
				concatVectors(out, grid[cols * (row - 1) + col + 1]);
			}
			
			//east
			if(canEast)
			{
				concatVectors(out, grid[cols * row + col + 1]);
			}
			
			//south east
			if(canSouth && canEast)
			{
				concatVectors(out, grid[cols * (row + 1) + col + 1]);
			}
			
			//south
			if(canSouth)
			{
				concatVectors(out, grid[cols * (row + 1) + col]);
			}
			
			//south west
			if(canSouth && canWest)
			{
				concatVectors(out, grid[cols * (row + 1) + col - 1]);
			}

			//place results into cache
			cache[gridSlot] = out;
			
			
			return out;
		}
		
		public function update(v:Vector.<DisplayObject>):void
		{
			//new data, reset the grid vector
			resetVectors(grid);
			
			//clear / result the cache
			clearCache();
			
			var col:uint;
			var row:uint;
			
			var slot:uint;
			
			//loop through DisplayObjects
			for each(var dobj:DisplayObject in v)
			{

				//find col / row
				col = uint(dobj.x / gridSize);
				row = uint(dobj.y / gridSize);

				//find the cell they are in
				slot = cols * row + col;

				//store it appropriate cell
				grid[slot].push(dobj);		
			}
		}
		
		//could move this to resetVectors and use same loop
		//clears the cache.
		//We save an allocation by not just doing a new Vector, 
		//although need to test which is faster
		//(Allocations are really expensive on devices, and take
		//memory, and possibly trigger the GC)
		private function clearCache():void
		{
			var len:int = cache.length;
			
			for(var i:int = 0; i < len; i++)
			{
				cache[i] = null;
			}
		}
		
		//resets all vectors in a multi-dimensional vectors
		//We just set legth to 0, instead of new Vector so we can prevent
		//new allocations
		private function resetVectors(vectors:Vector.<Vector.<DisplayObject>>):Vector.<Vector.<DisplayObject>>
		{
			for each(var vector:Vector.<DisplayObject> in vectors)
			{
				//this is significantly faster than calling new Vector
				vector.length = 0;
			}
			
			return vectors;
		}
		
	}

}