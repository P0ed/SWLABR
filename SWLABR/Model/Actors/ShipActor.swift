import Foundation
import SceneKit

class ShipActor: Actor {

	let attributes: ShipAttributes
	let node: SCNNode

	var armor: Double
	var shield: Double
	var energy: Double
	var thrusters: Double

	init(attributes: ShipAttributes, node: SCNNode) {

		self.attributes = attributes
		self.node = node

		armor = attributes.armor
		shield = attributes.shield
		energy = attributes.energy
		thrusters = 0.0
	}

	func update(input: ShipInput) {
		updateControls(input)
		updateStats()
	}

	func updateControls(input: ShipInput) {
		if thrusters > 0.7 {
			thrusters -= 0.01
		}
		thrusters = min(max(thrusters + 0.02 * input.throttle, 0), 1)

		let physicsBody = node.physicsBody!
		let presentationNode = node.presentationNode
		let orientation = presentationNode.orientation

		let fwd = CGFloat(thrusters * attributes.topSpeed * 0.01)
		let xRot = CGFloat(input.stick.x * attributes.turnRate * -0.01)
		let yRot = CGFloat(input.stick.y * attributes.turnRate * -0.01)

		if fwd > 0 {
			let force = Vector3(0.0, 0.0, -fwd) * orientation
			physicsBody.applyForce(force, impulse: false)
		}

		if abs(xRot) > 0 || abs(yRot) > 0 {
			let axis = Vector3(yRot, 0.0, xRot) * orientation
			let torque = Vector4(xyz: axis, w: 0.5)
			physicsBody.applyTorque(torque, impulse: false)
		}
	}

	func updateStats() {

		let thrustCost = thrusters < 0.7 ? thrusters * 0.1 : thrusters * 0.2
		if (energy > thrustCost) {
			energy -= thrustCost
		}

		let shieldRechargeCost = 0.04
		if shield < attributes.shield && energy > shieldRechargeCost {
			shield += min(shield + attributes.shield + 0.002, attributes.shield)
			energy -= shieldRechargeCost
		}

		energy = min(energy + attributes.energy * 0.002, attributes.energy)
	}
}
