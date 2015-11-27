package nf;

import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import openfl.display.Stage;

class Input {
	public static var instance(get, null): Input;

	private static function get_instance(): Input {
		if (instance == null) {
			instance = new Input();
		}
		return instance;
	}

	public static function getButton(btnName: String): Bool {
		return instance.buttons.get(btnName);
	}

	private var bindings: Map<Int, String>;
	public var buttons: Map<String, Bool>;

	public function bindEvents(stage: Stage) {
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}

	private function onKeyDown(e: KeyboardEvent) {
		if (bindings.exists(e.keyCode)) {
			buttons.set(bindings[e.keyCode], true);
		}
	}

	private function onKeyUp(e: KeyboardEvent) {
		if (bindings.exists(e.keyCode)) {
			buttons.set(bindings[e.keyCode], false);
		}
	}

	private function new() {
		bindings = new Map<Int, String>();
		buttons = new Map<String, Bool>();

		// Add default bindings
		bindings[Keyboard.W] = "Up";
		bindings[Keyboard.A] = "Left";
		bindings[Keyboard.S] = "Down";
		bindings[Keyboard.D] = "Right";

		bindings[Keyboard.UP] = "Up";
		bindings[Keyboard.LEFT] = "Left";
		bindings[Keyboard.DOWN] = "Down";
		bindings[Keyboard.RIGHT] = "Right";
	}
}
