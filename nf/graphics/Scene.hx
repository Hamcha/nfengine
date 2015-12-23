package nf.graphics;

import openfl.display.DisplayObject;
import nf.physics.Collider;
import openfl.events.Event;
import nf.physics.ICollidable;
import nf.physics.CollisionData;
import openfl.display.Sprite;
#if DEBUG_SHAPES
import nf.utils.DebugShapeDrawer;
#end

class Scene extends Sprite {
	public var camera: Camera;

	public function new() {
		super();
		camera = new Camera(this);

#if DEBUG_SHAPES
		// Collision debugger code
		var debugSprite: Sprite = new Sprite();
		var debugDrawer: DebugShapeDrawer = new DebugShapeDrawer(debugSprite.graphics);
		addChild(debugSprite);
		addEventListener(Event.ENTER_FRAME, function(e: Event) {
			setChildIndex(debugSprite, numChildren - 1);
			debugSprite.graphics.clear();
			for (cid in 0...numChildren) {
				var children: DisplayObject = getChildAt(cid);
				if (!Std.is(children, ICollidable)) {
					continue;
				}
				var collidable: ICollidable = cast(children, ICollidable);
				var collider: Collider = collidable.getCollider();
				if (collider != null && collider.shape != null) {
					debugDrawer.drawShape(collider.shape);
				}
			}
		});
#end
	}

	public function collides(actor: Actor, category: String): Array<Collision> {
		var collisions = new Array<Collision>();

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
			var collisionData: CollisionData = collidable.collides(actor.getCollider());

			// Ignore if it doesn't belong to the category we're searching for
			if (category != "all" && collidable.getCategory() != category) {
				continue;
			}

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
}
