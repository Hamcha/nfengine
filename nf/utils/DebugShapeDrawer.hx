package nf.utils;

import differ.shapes.Circle;
import openfl.display.Graphics;
import differ.math.Vector;
import differ.ShapeDrawer;

// Based on the good ol' OpenFLDrawer
class DebugShapeDrawer extends ShapeDrawer {
	private var graphics: Graphics;

	public function new(_graphics: Graphics) {
		super();
		this.graphics = _graphics;
	}

	public override function drawLine(p0:Vector, p1:Vector, ?startPoint:Bool = true) {
		lineStyle();
		if (startPoint) {
			this.graphics.moveTo(p0.x, p0.y);
		}
		this.graphics.lineTo(p1.x, p1.y);
	}

	public override function drawCircle(circle:Circle) {
		lineStyle();
		this.graphics.drawCircle(circle.x, circle.y, circle.transformedRadius);
	}

	public override function drawVector(p0:Vector, p1:Vector, ?startPoint:Bool = true) {
		lineStyle();
		drawLine(p0, p1);
		this.graphics.drawCircle(p1.x, p1.y, 2);
	}

	private function lineStyle() {
		this.graphics.lineStyle(1, 0xff0000);
	}
}