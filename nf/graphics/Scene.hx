package nf.graphics;

import nf.physics.Collider;
import nf.physics.ICollidable;
import nf.physics.CollisionData;

#if INSPECTOR
import nf.utils.Inspector;
#end

import openfl.display.DisplayObject;
import openfl.display.Sprite;

class Scene extends Sprite {
	public var camera: Camera;
	public var inspector: Inspector;
	public var active: Bool = true;

	public function new() {
		super();
		camera = new Camera(this);

#if INSPECTOR
		inspector = new Inspector();
		addActor(inspector);
#end
	}

	public function collides(actor: Actor, category: String): Array<Collision> {
		var collisions = new Array<Collision>();
		var collider = actor.getCollider();

		// Loop through childrens
		for (cid in 0...numChildren) {
			var children: DisplayObject = getChildAt(cid);

			// Can't collide with self
			if (children == actor) {
				continue;
			}

			// Only check for collidable objects
			if (!Std.is(children, ICollidable)) {
				continue;
			}

			var collidable: ICollidable = cast(children, ICollidable);
			// Ignore if it doesn't belong to the category we're searching for
			if (category != "all" && collidable.getCategory() != category) {
				continue;
			}

			var collisionData: CollisionData = collidable.collides(collider);
			if (collisionData != null && collisionData.collided) {
				collisions.push(new Collision(collisionData, actor, collidable));
			}
		}

		return collisions;
	}

	public function addActor(actor: Actor) {
		actor.scene = this;
		addChild(actor);
	}

	public function freeze() {
		active = false;
		// Stop all actors
		for (cid in 0...numChildren) {
			var children: DisplayObject = getChildAt(cid);
			if (Std.is(children, Actor)) {
				cast(children, Actor).active = false;
			}
		}
	}
}
