package nf.physics;

import differ.data.ShapeCollision;

class Collision {
	public var data: CollisionData;
	public var first: ICollidable;
	public var second: ICollidable;

	public function new(data: CollisionData, first: ICollidable, second: ICollidable) {
		this.data = data;
		this.first = first;
		this.second = second;
	}

	public static inline function other(collision: Collision, you: ICollidable): ICollidable {
		return you == collision.first ? collision.second : collision.first;
	}
}

class CollisionData {
	public var collided(get, null): Bool;
	public var collision: ShapeCollision = null;

	public function new(collision: ShapeCollision) {
		this.collision = collision;
	}

	public function Combine(data: CollisionData) {
		if (!data.collided) {
			return;
		}

		collision.separation = collision.separation.add(data.collision.separation);
	}

	public function get_collided(): Bool {
		return collision != null;
	}
}
