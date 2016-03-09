import Foundation

final class InputComponent: ControlComponent {

	let inputController: InputController
	var thrusters = 0.0

	init(_ inputController: InputController) {
		self.inputController = inputController
	}

	func update(node: EntityNode) {
		let input = inputController.currentInput()
		let shipBehavior = node.behaviorComponent as! ShipBehavior

		if thrusters > 0.7 {
			thrusters -= 0.01
		}
		thrusters = min(max(thrusters + 0.02 * input.throttle, 0), 1)

		shipBehavior.control(node,
			fwd: thrusters * 0.02,
			roll: input.stick.dx * 0.01,
			pitch: input.stick.dy * 0.01,
			yaw: input.rudder * 0.01
		)

		if input.fireBlaster {
			shipBehavior.fireBlaster(node)
		}
	}
}
