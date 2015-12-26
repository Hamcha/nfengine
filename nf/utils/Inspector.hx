package nf.utils;

import nf.physics.CollisionData.Collision;
import nf.graphics.Scene;

class Inspector {
	public static inline function showCollision(scene: Scene, collision: Collision) {
#if DEBUG_SHAPES
		scene.freeze();
		scene.dbgShowCollision(collision);
#else
#error "Collision debugging is disabled. Remove calls to it or define DEBUG_SHAPES"
#end
	}
}
