package nf.physics;

import differ.shapes.Shape;
import differ.shapes.Circle;

class CircleCollider extends Collider {
	public function new(radius: Float) {
		shape = new Circle(0, 0, radius);
	}
}
