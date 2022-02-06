import Foundation
import GameController
import Combine

final class HIDController {

	private var current: GCController? = GCController.controllers().first {
		didSet { if let some = current { setupController(some) } }
	}
	private var observers: [Any] = []
	@IO private var controls = Controls()

	let eventsController = EventsController()

	init() {
		observers = [
			NotificationCenter.default.publisher(for: .GCControllerDidBecomeCurrent).sink { [weak self] in
				self?.current = $0.object as? GCController
			},
			NotificationCenter.default.publisher(for: .GCControllerDidStopBeingCurrent).sink { [weak self] _ in
				self?.current = nil
			}
		]
	}

	private func setupController(_ controller: GCController) {
		guard let gamepad = controller.extendedGamepad else { return }
		_controls.value = Controls()

		gamepad.leftThumbstick.valueChangedHandler = { [_controls, eventsController] _, x, y in
			_controls.value.leftStick = Controls.Thumbstick(x: x, y: y)
			eventsController.handleLeftThumbstick(Controls.Thumbstick(x: x, y: y))
		}
		gamepad.rightThumbstick.valueChangedHandler = { [_controls, eventsController] _, x, y in
			_controls.value.rightStick = Controls.Thumbstick(x: x, y: y)
			eventsController.handleRightThumbstick(Controls.Thumbstick(x: x, y: y))
		}
		gamepad.leftTrigger.valueChangedHandler = { [_controls, eventsController] _, value, _ in
			_controls.value.leftTrigger = value
			eventsController.handleLeftTrigger(value)
		}
		gamepad.rightTrigger.valueChangedHandler = { [_controls, eventsController] _, value, _ in
			_controls.value.rightTrigger = value
			eventsController.handleRightTrigger(value)
		}

		let mapControl: (GCControllerButtonInput, Controls.Buttons) -> Void = { [_controls, eventsController] button, control in
			button.valueChangedHandler = { _, _, pressed in
				_controls.modify { if pressed { $0.buttons.insert(control) } else { $0.buttons.remove(control) } }
				eventsController.handleButton(control, isPressed: pressed)
			}
		}
		mapControl(gamepad.buttonA, .cross)
		mapControl(gamepad.buttonB, .circle)
		mapControl(gamepad.dpad.up, .up)
		mapControl(gamepad.dpad.down, .down)
		mapControl(gamepad.dpad.left, .left)
		mapControl(gamepad.dpad.right, .right)
		mapControl(gamepad.leftShoulder, .shiftLeft)
		mapControl(gamepad.rightShoulder, .shiftRight)
		mapControl(gamepad.buttonX, .square)
		mapControl(gamepad.buttonY, .triangle)
		mapControl(gamepad.buttonMenu, .scan)
	}
}

struct Controls {
	var leftStick = Thumbstick.zero
	var rightStick = Thumbstick.zero
	var leftTrigger = 0 as Float
	var rightTrigger = 0 as Float
	var buttons = [] as Buttons

	struct Buttons: OptionSet, Hashable {
		var rawValue: Int16 = 0

		static let up = Buttons(rawValue: 1 << 0)
		static let down = Buttons(rawValue: 1 << 1)
		static let left = Buttons(rawValue: 1 << 2)
		static let right = Buttons(rawValue: 1 << 3)
		static let shiftLeft = Buttons(rawValue: 1 << 4)
		static let shiftRight = Buttons(rawValue: 1 << 5)
		static let cross = Buttons(rawValue: 1 << 6)
		static let circle = Buttons(rawValue: 1 << 7)
		static let square = Buttons(rawValue: 1 << 8)
		static let triangle = Buttons(rawValue: 1 << 9)
		static let scan = Buttons(rawValue: 1 << 10)

		static let dPad = Buttons([.up, .down, .left, .right])
	}

	struct Thumbstick {
		var x: Float
		var y: Float

		static let zero = Thumbstick(x: 0, y: 0)
	}
}
