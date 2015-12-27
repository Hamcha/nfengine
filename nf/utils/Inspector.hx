package nf.utils;

import nf.physics.Collider;
import nf.physics.ICollidable;
import nf.physics.CollisionData.Collision;
import nf.graphics.Scene;

import openfl.display.Sprite;
import openfl.display.DisplayObject;
import openfl.events.Event;

enum InspectState {
	ShowColliders;
	InspectCollision;
}

class Inspector extends Actor {
	private var debugSprite: Sprite;
	private var debugDrawer: DebugShapeDrawer;
	private var debugShapes: Bool = false;
	private var inspectorState: InspectState = InspectState.ShowColliders;
	private var currentCollision: Collision = null;

	public function new() {
		super();
		debugSprite = new Sprite();
		debugDrawer = new DebugShapeDrawer(debugSprite.graphics);
		addChild(debugSprite);
	}

	private override function _update(e: Event) {
		switch (inspectorState) {
			case InspectState.ShowColliders:
				renderColliderShapes();
			case InspectState.InspectCollision:
				renderCollision();
		}
	}

	private function renderColliderShapes() {
		scene.setChildIndex(this, scene.numChildren - 1);
		debugSprite.graphics.clear();
		for (cid in 0...scene.numChildren) {
			var children: DisplayObject = scene.getChildAt(cid);
			if (!Std.is(children, ICollidable)) {
				continue;
			}
			var collidable: ICollidable = cast(children, ICollidable);
			var collider: Collider = collidable.getCollider();
			if (collider != null && collider.shape != null) {
				debugDrawer.drawShape(collider.shape);
			}
		}
	}

	private function renderCollision() {
		if (currentCollision == null) { return; }

		scene.setChildIndex(this, scene.numChildren - 1);
		debugSprite.graphics.clear();

		// Black overlay
		debugSprite.graphics.beginFill(0, 0.4);
		debugSprite.graphics.drawRect(0, 0, scene.width, scene.height);
		debugSprite.graphics.endFill();

		// Draw collision
		debugDrawer.drawShape(currentCollision.first.getCollider().shape);
		debugDrawer.drawShape(currentCollision.second.getCollider().shape);
		debugDrawer.drawShapeCollision(currentCollision.data.collision);
	}

	public function inspectCollision(collision: Collision) {
#if INSPECTOR
		scene.freeze();
		currentCollision = collision;
		inspectorState = InspectState.InspectCollision;
#else
		#error "The inspector is disabled, remove the debug code or define -D inspector"
#end
	}
}
