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
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public final class DisplayObjectUtil
	{
		public static function hitTestCircle(bounds1:Rectangle, bounds2:Rectangle):Boolean
		{
			var dx:Number = bounds2.x  - bounds1.x;
			var dy:Number = bounds2.y  - bounds1.y ;

			var radii:Number = ((bounds1.width * .5) + (bounds2.width * .5));
			return ((dx * dx) + (dy * dy) < radii * radii);
		}
	}
}