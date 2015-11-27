package nf;

import nf.graphics.Scene;
import nf.physics.Collider;
import nf.physics.CollisionData;
import nf.physics.NullCollider;
import nf.physics.ICollidable;
import openfl.display.Sprite;

class Actor extends Sprite implements ICollidable {
	public var collider: Collider;
	public var scene: Scene;

	public function new() {
		super();
		collider = new NullCollider();
	}

	public function collides(collider: Collider): CollisionData {
		updateCollider();
		return collider.test(collider);
	}

	public function getCollider(): Collider {
		updateCollider();
		return collider;
	}

	private function updateCollider() {
		collider.setPosition(x, y);
		collider.setRotation(rotation);
	}
}
