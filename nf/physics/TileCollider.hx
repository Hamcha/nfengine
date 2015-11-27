package nf.physics;

import nf.graphics.Tilemap.CollisionLayer;
import differ.shapes.Polygon;

enum TileCollisionType {
	NULL;
	FULL;
	TOPHALF;
	BOTTOMHALF;
	LEFTHALF;
	RIGHTHALF;
	TRI_DR;
	TRI_DL;
	TRI_UR;
	TRI_UL;
}

class TileCollider extends Collider {
	public var layer: CollisionLayer;
	private var mapWidth: Int;

	public function new(layer: CollisionLayer, mapWidth: Int) {
		this.layer = layer;
		this.mapWidth = mapWidth;
	}

	public override function test(collider: Collider): CollisionData {
		if (collider == null || collider.shape == null) {
			return new CollisionData(null);
		}

		var tileX: Int = Math.floor(collider.shape.x / layer.tileWidth);
		var tileY: Int = Math.floor(collider.shape.y / layer.tileHeight);

		// Check current tile and neighbourgs
		var tiles: Array<Array<Int>> = [
			[tileX, tileY],
			[tileX, tileY-1],
			[tileX-1, tileY],
			[tileX-1, tileY-1],
			[tileX+1, tileY+1],
			[tileX+1, tileY-1],
			[tileX-1, tileY+1],
			[tileX+1, tileY],
			[tileX, tileY+1]
		];

		var collision: CollisionData = null;
		for (tile in tiles) {
			var cdata = checkTileCollision(collider, tile[0], tile[1]);
			if (cdata.collided) {
				if (collision == null) {
					collision = cdata;
				} else {
					collision.Combine(cdata);
				}
			}
		}

		if (collision == null) {
			return new CollisionData(null);
		}
		return collision;
	}

	private function checkTileCollision(collider: Collider, x: Int, y: Int): CollisionData {
		var tileId: Int = y * mapWidth + x;

		if (tileId < 0 || tileId >= layer.layerData.length) {
			return new CollisionData(null);
		}

		var tileCollisionType: TileCollisionType = layer.layerData[tileId];
		switch(tileCollisionType) {
			case TileCollisionType.FULL:
				shape = Polygon.rectangle(0, 0, layer.tileWidth, layer.tileHeight, false);
			case TileCollisionType.NULL:
				shape = null;
			default:
				return new CollisionData(null);
		}
		setPosition(x * layer.tileWidth, y * layer.tileHeight);

		return collider.test(this);
	}
}
