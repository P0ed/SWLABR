import Foundation

final class InputController {

	let eventsController: EventsController

	var buttonsState: Int = 0

	init(_ eventsController: EventsController) {
		self.eventsController = eventsController

		let buttonAction: DSButton -> DeviceAction = {
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

		let buttonActions: [DSButton: DeviceAction] = [
			.Square: buttonAction(.Square),
			.Cross: buttonAction(.Cross),
			.L2: buttonAction(.L2),
			.R2: buttonAction(.R2)
		]

		eventsController.deviceConfiguration = DeviceConfiguration(
			buttonsMapTable: buttonActions,
			dPadMapTable: [:],
			keyboardMapTable: [:]
		)
	}

	func buttonPressed(button: DSButton) -> Bool {
		return buttonsState & 1 << button.rawValue != 0
	}

	func currentInput() -> ShipInput {
		var input = ShipInput()
		input.throttle = eventsController.leftJoystick.dy
		input.stick = StickInput(x: eventsController.rightJoystick.dx, y: eventsController.rightJoystick.dy)
		input.fireTorpedo = buttonPressed(.L2)
		input.fireBlaster = buttonPressed(.R2)

		return input
	}
}
