package nf.physics;

class NullCollider extends Collider {
	public function new() {}
	public override function test(collider: Collider): CollisionData {
		return new CollisionData(null);
	}

	public override function setPosition(x: Float, y: Float): Void {}
	public override function setRotation(rot: Float): Void {}
}
