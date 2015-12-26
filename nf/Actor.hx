package nf;

import nf.utils.EventUtils;
import openfl.events.Event;
import nf.graphics.Scene;
import nf.physics.Collider;
import nf.physics.CollisionData;
import nf.physics.NullCollider;
import nf.physics.ICollidable;

import openfl.display.Sprite;

class Actor extends Sprite implements ICollidable {
	public var collider: Collider;
	public var scene: Scene;
	public var active: Bool = true;

	public function new() {
		super();
		collider = new NullCollider();
		EventUtils.update(this, _update);
	}

	private function _update(e: Event) {
		if (active) {
			update();
		}
	}

	private function update() {}

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

	public function getCategory() {
		return "none";
	}

	public function dispose() {
		EventUtils.clearUpdate(this, _update);
	}

	public function isOutsideScene() {
		return x+width < scene.scrollRect.left || x-width > scene.scrollRect.right ||
		        y+height < scene.scrollRect.top || y-height > scene.scrollRect.bottom;
	}

	public static inline function destroy(a: Actor) {
		a.dispose();
		a.parent.removeChild(a);
		a = null;
	}
}
