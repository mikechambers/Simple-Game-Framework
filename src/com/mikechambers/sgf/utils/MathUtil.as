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

package com.mikechambers.sgf.utils
{
	import flash.geom.Point;
	
	public final class MathUtil
	{
		//todo: reuse
		public static function degreesToRadians(degrees:Number):Number
		{
			return (degrees * Math.PI / 180);
		}
		
		//todo: reuse
		public static function radiansToDegrees(radians:Number):Number
		{
			return radians * 180 / Math.PI;
		}
		
		//returns angle in radians
		public static function getAngleBetweenPoints(p1:Point, p2:Point):Number
		{
			var dx:Number = p1.x - p2.x;
			var dy:Number = p1.y - p2.y;
			var radians:Number = Math.atan2(dy, dx);
			return radians;
		}
		
		public static function distanceBetweenPoints(p1:Point, p2:Point):Number
		{
			var dx:Number = p1.x - p2.x;
			var dy:Number = p1.y - p1.y;
			var dist:Number = Math.sqrt(dx * dx + dy * dy);
			
			return dist;
		}
		
		public static function abs(value:Number):Number
		{
			//http://lab.polygonal.de/2007/05/10/bitwise-gems-fast-integer-math/
			return (value ^ (value >> 31)) - (value >> 31);
		}
	}
}

