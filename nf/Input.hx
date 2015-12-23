package nf;

import openfl.ui.GameInputDevice;
import openfl.events.GameInputEvent;
import openfl.events.KeyboardEvent;
import openfl.display.Stage;
import openfl.ui.GameInput;

class Input {
	public static var instance(get, null): Input;

	private static function get_instance(): Input {
		if (instance == null) {
			instance = new Input();
		}
		return instance;
	}

	private var ginput: GameInput;

	public static function getButton(btnName: String): Float {
		return instance.buttons.get(btnName);
	}

	private var pads: Map<Int, GameInputDevice>;

	public var kb: Map<Int, String>;
	public var pad: Map<Int, String>;
	public var buttons: Map<String, Float>;

	public var enablekb: Bool;
	public var enablepad: Bool;

	private function get_gamepad(id: Int): GameInputDevice {
		return GameInput.getDeviceAt(id);
	}

	public function bindEvents(stage: Stage) {
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

		ginput.addEventListener(GameInputEvent.DEVICE_ADDED, controllerAdded);
		ginput.addEventListener(GameInputEvent.DEVICE_REMOVED, controllerRemoved);
		ginput.addEventListener(GameInputEvent.DEVICE_UNUSABLE, controllerProblem);
	}

	private function controllerAdded(e: GameInputEvent) {
		trace(e);
	}

	private function controllerRemoved(e: GameInputEvent) {
		trace(e);
	}

	private function controllerProblem(e: GameInputEvent) {
		trace(e);
	}

	private function onKeyDown(e: KeyboardEvent) {
		if (kb.exists(e.keyCode)) {
			buttons.set(kb[e.keyCode], 1);
		}
	}

	private function onKeyUp(e: KeyboardEvent) {
		if (kb.exists(e.keyCode)) {
			buttons.set(kb[e.keyCode], 0);
		}
	}

	private function updatePad() {
		//TODO Update controller table
	}

	private function new() {
		enablekb = true;
		enablepad = false;

		kb = new Map<Int, String>();
		buttons = new Map<String, Float>();

		ginput = new GameInput();
	}
}
