package nf;

import openfl.ui.GameInputControl;
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

	public static function getButton(btnName: String): Float {
		return instance.buttons.get(btnName);
	}

	// Syntactic sugar for a analog-like version of getButton
	public static function getAxis(btnName: String): Float {
		return Input.getButton(btnName) * 2 - 1;
	}

	public static var GamepadCount: Int = 0;

	private var pads: Array<GameInputDevice>;
	private var ginput: GameInput;

	public var kb: Map<Int, String>;
	public var gamepad: Map<String, String>;
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
		e.device.enabled = true;
		pads.push(e.device);
		GamepadCount++;
	}

	private function controllerRemoved(e: GameInputEvent) {
		pads.remove(e.device);
		GamepadCount--;
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

	public function updatePad() {
		for (pid in 0...pads.length) {
			var pad: GameInputDevice = pads[pid];
			for (cid in 0...pad.numControls) {
				var control: GameInputControl = pad.getControlAt(cid);
				var pcid: String = pid + "-" + control.id;
				if (gamepad.exists(pcid)) {
					var normalized: Float = (control.value - control.minValue) / (control.maxValue - control.minValue); // Inverse Lerp
					buttons.set(gamepad[pcid], normalized);
				}
			}
		}
	}

	private function new() {
		enablekb = true;
		enablepad = true;

		kb = new Map<Int, String>();
		buttons = new Map<String, Float>();
		gamepad = new Map<String, String>();
		pads = new Array<GameInputDevice>();

		ginput = new GameInput();
	}
}
