import Foundation

final class InputController {

	let eventsController: EventsController

	var buttonsState: Int = 0

	init(_ eventsController: EventsController) {
		self.eventsController = eventsController

		let buttonAction: (Controls.Buttons) -> DeviceAction = {
			button in
			return DeviceAction {
				pressed in
				if pressed {
					self.buttonsState |= 1 << button.rawValue
				} else {
					self.buttonsState &= ~(1 << button.rawValue)
				}
			}
		}

		let buttonActions: [Controls.Buttons: DeviceAction] = [
			.square: buttonAction(.square),
			.cross: buttonAction(.cross),
			.shiftLeft: buttonAction(.shiftLeft),
			.shiftRight: buttonAction(.shiftRight)
		]

		eventsController.deviceConfiguration = DeviceConfiguration(
			buttonsMapTable: buttonActions
		)
	}

	func buttonPressed(_ button: Controls.Buttons) -> Bool {
		return buttonsState & 1 << button.rawValue != 0
	}

	func currentInput() -> ShipInput {
		var input = ShipInput()
		input.throttle = eventsController.leftJoystick.dy
		input.rudder = eventsController.leftJoystick.dx
		input.stick = eventsController.rightJoystick
		input.fireTorpedo = buttonPressed(.shiftLeft)
		input.fireBlaster = buttonPressed(.shiftRight)

		return input
	}
}
