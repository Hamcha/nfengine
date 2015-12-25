package nf.graphics;

import nf.physics.Collider;
import nf.physics.ICollidable;
import nf.physics.TileCollider;
import nf.physics.CollisionData;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.display.Tilesheet;
import openfl.display.BitmapData;
import openfl.display.Sprite;

class Tileset {
	public var name: String;
	public var basegid: Int;
	public var endgid: Int;
	public var tilesheet: Tilesheet;

	public function new(argName: String, bitmap: BitmapData, tileWidth: Int, tileHeight: Int, startgid: Int) {
		basegid = startgid;
		name = argName;

		tilesheet = new Tilesheet(bitmap);

		var tileRows: Int = Math.floor(bitmap.width / tileWidth);
		var tileCols: Int = Math.floor(bitmap.height / tileHeight);

		endgid = basegid + tileRows * tileCols;

		// Get spritesheet frames
		for (y in 0...tileCols) {
			for (x in 0...tileRows) {
				tilesheet.addTileRect(new Rectangle(x * tileWidth, y * tileHeight, (x + 1) * tileWidth, (y + 1) * tileHeight));
			}
		}
	}
}

class MapLayer {
	public var layerData: Array<Float>;
	public var maxgid: Int;
	public var mingid: Int;

	public function new(tiles: Array<Int>, layerWidth: Int, layerHeight: Int, tileWidth: Int, tileHeight: Int) {
		layerData = new Array<Float>();
		var index: Int = 0;
		var maxgid: Int = 0;
		var mingid: Int = 99999;
		for (y in 0...layerHeight) {
			for (x in 0...layerWidth) {
				var tileId: Int = tiles[index];

				// Check for mingid/maxgid
				if (mingid > tileId) {
					mingid = tileId;
				}
				if (maxgid < tileId) {
					maxgid = tileId;
				}

				// Order is: X, Y, TileID, …
				layerData.push(Std.int(x * tileWidth));
				layerData.push(Std.int(y * tileHeight));
				layerData.push(tileId);
				index++;
			}
		}
	}

	public function forTileset(tileset: Tileset): Array<Float> {
		var subLayerData: Array<Float> = new Array<Float>();
		for (i in 0...layerData.length*3) {
			var gid: Int = Math.floor(layerData[i*3+2]);
			if (gid >= tileset.basegid && gid <= tileset.endgid) {
				subLayerData.push(layerData[i*3]);
				subLayerData.push(layerData[i*3+1]);
				subLayerData.push(gid - tileset.basegid);
			}
		}

		return subLayerData;
	}
}

class CollisionLayer {
	public var layerData: Array<TileCollisionType>;
	public var width: Int;
	public var height: Int;
	public var tileWidth: Int;
	public var tileHeight: Int;

	public function new(collisionIDs: Array<TileCollisionType>, width: Int, height: Int, tileWidth: Int, tileHeight: Int) {
		layerData = collisionIDs;
		this.width = width;
		this.height = height;
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
	}
}

class Tilemap extends Sprite implements ICollidable {
	private var tilewidth: Int;
	private var tileheight: Int;
	private var mapwidth: Int;
	private var mapheight: Int;
	private var tilecollider: TileCollider;

	public var tilesets: Array<Tileset>;
	public var layers: Array<MapLayer>;
	public var collision(get, set): CollisionLayer;

	public function new(
			argName: String,
			argWidth: Int,
			argHeight: Int,
			argTileWidth: Int,
			argTileHeight: Int) {
		super();
		name = argName;
		mapwidth = argWidth;
		mapheight = argHeight;
		tilewidth = argTileWidth;
		tileheight = argTileHeight;

		tilesets = new Array<Tileset>();
		layers = new Array<MapLayer>();

		addEventListener(Event.ADDED_TO_STAGE, function(e: Event){
			stage.addEventListener(Event.ENTER_FRAME, render);
		});
	}

	private function render(e: Event) {
		this.graphics.clear();
		// Draw all layers
		for (layer in layers) {
			for (tileset in tilesets) {
				tileset.tilesheet.drawTiles(graphics, layer.forTileset(tileset), false);
			}
		}
	}

	public function mapWidth(): Float {
		return mapwidth * tilewidth;
	}

	public function mapHeight(): Float {
		return mapheight * tileheight;
	}

	private function set_collision(layer: CollisionLayer): CollisionLayer {
		tilecollider = new TileCollider(layer, mapwidth);
		return layer;
	}

	private function get_collision(): CollisionLayer {
		return tilecollider.layer;
	}

	public function collides(collider: Collider): CollisionData {
		if (tilecollider != null) {
			return tilecollider.test(collider);
		}
		return new CollisionData(null);
	}

	public function getCollider(): Collider {
		return tilecollider;
	}

	public function getCategory(): String {
		return "map";
	}
}
