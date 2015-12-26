package nf.utils;

import openfl.display.Bitmap;

class BitmapUtils {
	public static inline function centerOrigin(b: Bitmap) {
		b.x = -b.width/2;
		b.y = -b.height/2;
	}
}
