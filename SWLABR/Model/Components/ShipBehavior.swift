import Foundation

final class ShipBehavior: BehaviorComponent {

	let attributes: ShipAttributes

	var armor: Double
	var shield: Double
	var energy: Double

	var blasterCD: Double = 0.0

	init(attributes: ShipAttributes) {
		self.attributes = attributes

		armor = attributes.armor
		shield = attributes.shield
		energy = attributes.energy
	}

	func update(node: EntityNode, inEngine engine: GameEngine) {
		updateStats()
	}

	func control(node: EntityNode, fwd: Double, roll: Double, pitch: Double, yaw: Double) {
		let physicsBody = node.physicsBody!
		let orientation = node.presentationNode.orientation

		if fwd > 0 {
			let force = Vector3(0.0, 0.0, -fwd) * CGFloat(attributes.topSpeed) * orientation
			physicsBody.applyForce(force, impulse: false)
		}

		if abs(roll) > 0 || abs(pitch) > 0 || abs(yaw) > 0 {
			let turnRate = CGFloat(attributes.turnRate)
			let axis = Vector3(-pitch, -yaw, -roll) * Vector3(turnRate, 0.4 * turnRate, turnRate) * orientation
			let torque = Vector4(xyz: axis, w: 0.5)
			physicsBody.applyTorque(torque, impulse: false)
		}
	}

	func fireBlaster(node: EntityNode) {
		if blasterCD == 0.0 {

			let blasterNode = SpaceSceneFabric.createBlasterNode()

			let presentationNode = node.presentationNode
			let orientation = presentationNode.orientation

			blasterNode.position = presentationNode.position + Vector3(0, 0, -2) * orientation
			blasterNode.orientation = node.presentationNode.orientation
			blasterNode.physicsBody?.velocity = Vector3(0, 0, -20) * orientation
			node.parentNode?.addChildNode(blasterNode)

			let time = dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC * 3))
			dispatch_after(time, dispatch_get_main_queue()) {
				blasterNode.removeFromParentNode()
			}

			blasterCD = 0.2
		}
	}

	private func updateStats() {

		let shieldRechargeCost = 0.04
		if shield < attributes.shield && energy > shieldRechargeCost {
			shield += min(shield + attributes.shield + 0.002, attributes.shield)
			energy -= shieldRechargeCost
		}

		energy = min(energy + attributes.energy * 0.002, attributes.energy)

		blasterCD = max(blasterCD - GameEngine.timeStep, 0.0)
	}
}
