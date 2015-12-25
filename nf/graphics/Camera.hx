package nf.graphics;

import openfl.geom.Rectangle;
import openfl.display.DisplayObject;

class Camera extends Rectangle {
	private var container: DisplayObject;
	private var scaleX: Float;
	private var scaleY: Float;

	public function new(argContainer: DisplayObject){
		super(0, 0, Screen.width, Screen.height);
		container = argContainer;
	}

	public function moveToCoords(x: Float, y: Float) {
		var baseX: Float = width * 0.5;
		var baseY: Float = height * 0.5;

		this.x = Std.int(baseX - x * scaleX);
		this.y = Std.int(baseY - y * scaleY);

		container.x = this.x;
		container.y = this.y;
	}

	public function moveToObject(object: DisplayObject) {
		var baseX: Float = width * 0.5;
		var baseY: Float = height * 0.5;

		this.x = Std.int(baseX - object.x * scaleX);
		this.y = Std.int(baseY - object.y * scaleY);

		container.x = this.x;
		container.y = this.y;
	}

	public function zoom(scaleX: Float, scaleY: Float) {
		this.scaleX = container.scaleX = scaleX;
		this.scaleY = container.scaleY = scaleY;
	}
}
