package nf.graphics;

import openfl.Lib;

class Screen {
	static public var width(get,null): Int;
	static public var height(get,null): Int;

	static function get_width(): Int {
		return Lib.current.stage.stageWidth;
	}
	static function get_height(): Int {
		return Lib.current.stage.stageHeight;
	}

	static public inline function relX(positionX: Float): Int {
		return Math.round(Screen.width * positionX);
	}
	static public inline function relY(positionY: Float): Int {
		return Math.round(Screen.height * positionY);
	}

	static public inline function sceneRelX(scene: Scene, pX: Float): Int {
		return Math.round(scene.scrollRect.width * pX);
	}

	static public inline function sceneRelY(scene: Scene, pY: Float): Int {
		return Math.round(scene.scrollRect.height * pY);
	}
}
