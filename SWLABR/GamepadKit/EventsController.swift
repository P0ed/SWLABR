import Foundation

final class EventsController {
	var deviceConfiguration = DeviceConfiguration()

	var leftJoystick = DSVector.zeroVector
	var rightJoystick = DSVector.zeroVector
	var leftTrigger = 0.0
	var rightTrigger = 0.0
	var hatDirection = DSHatDirection.Null

	func handleLeftThumbstick(_ stick: Controls.Thumbstick) {
		leftJoystick = DSVector(dx: Double(stick.x), dy: Double(stick.y))
	}
	func handleRightThumbstick(_ stick: Controls.Thumbstick) {
		rightJoystick = DSVector(dx: Double(stick.x), dy: Double(stick.y))
	}
	func handleLeftTrigger(_ value: Float) {
		leftTrigger = Double(value)
	}
	func handleRightTrigger(_ value: Float) {
		rightTrigger = Double(value)
	}
	func handleButton(_ button: Controls.Buttons, isPressed: Bool) {
		if let action = deviceConfiguration.buttonsMapTable[button] {
			action.performAction(isPressed)
		}
	}
}
