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

		if let physicsBody = node.physicsBody {

			let fwd = CGFloat(thrusters * attributes.topSpeed * -0.001)
			let xRot = CGFloat(input.stick.x * attributes.turnRate)
			let yRot = CGFloat(input.stick.y * attributes.turnRate)

			let orientation = node.orientation

			let force = SCNVector3(
				x: fwd * orientation.y,
				y: fwd * orientation.z,
				z: fwd * orientation.w
			)

			physicsBody.applyForce(force, impulse: true)

//			node.rotation = SCNVector4(
//				x: xRot * 0.01,
//				y: yRot * 0.01,
//				z: 0.0,
//				w: 1.0
//			)
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
