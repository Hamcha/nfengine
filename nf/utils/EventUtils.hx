package nf.utils;

import openfl.events.Event;
import openfl.display.DisplayObject;

class EventUtils {
	public static function update(obj: DisplayObject, fn: Event -> Void) {
		obj.addEventListener(Event.ADDED_TO_STAGE, function(e: Event) {
			obj.stage.addEventListener(Event.ENTER_FRAME, fn);
		});
	}
	public static function clearUpdate(obj: DisplayObject, fn: Event -> Void) {
		obj.stage.removeEventListener(Event.ENTER_FRAME, fn);
	}
}
