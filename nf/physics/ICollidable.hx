package nf.physics;

interface ICollidable {
	public function collides(collider: Collider): CollisionData;
	public function getCollider(): Collider;
	public function getCategory(): String;
}
