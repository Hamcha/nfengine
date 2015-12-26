package nf.physics;

import openfl.geom.Point;

import differ.shapes.Shape;

class Collider {
	public var shape(default, null): Shape = null;
	public var offset: Point = new Point(0, 0);

	public function setOffset(x: Float, y: Float) {
		offset = new Point(x, y);
	}

	public function setPosition(x: Float, y: Float) {
		if (shape == null) {
			return;
		}
		shape.x = x + offset.x;
		shape.y = y + offset.y;
	}

	public function setRotation(rotation: Float) {
		if (shape == null) {
			return;
		}
		shape.rotation = rotation;
	}

	public function test(collider: Collider): CollisionData {
		if (shape == null || collider == null || collider.shape == null) {
			return new CollisionData(null);
		}
		return new CollisionData(shape.test(collider.shape));
	}
}
