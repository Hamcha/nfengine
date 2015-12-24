package nf.physics;

import openfl.geom.Rectangle;
import differ.shapes.Shape;
import differ.shapes.Polygon;

class BoxCollider extends Collider {
	public function new(rect: Rectangle) {
		shape = Polygon.rectangle(rect.x, rect.y, rect.width, rect.height);
	}
}
