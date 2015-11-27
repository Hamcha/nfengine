package nf;

import openfl.display.Sprite;
import openfl.events.Event;

class GameState extends Sprite {
	private function new() {
		super();
		// Setup update event
		addEventListener(Event.ADDED_TO_STAGE, function(e: Event){
			initialize(e);
			stage.addEventListener(Event.ENTER_FRAME, update);
		});
	}

	public function load() {	}
	public function unload() { }

	public function initialize(e: Event) { }
	public function update(e: Event) { }
}
