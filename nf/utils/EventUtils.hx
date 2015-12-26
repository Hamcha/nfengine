package nf.utils;

import openfl.events.Event;
import openfl.display.DisplayObject;

class EventUtils {
	public static inline function update(obj: DisplayObject, fn: Event -> Void) {
		obj.addEventListener(Event.ADDED_TO_STAGE, function(e: Event) {
			obj.stage.addEventListener(Event.ENTER_FRAME, fn);
		});
	}
	public static inline function clearUpdate(obj: DisplayObject, fn: Event -> Void) {
		obj.stage.removeEventListener(Event.ENTER_FRAME, fn);
	}
}
