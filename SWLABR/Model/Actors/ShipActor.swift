import Foundation

class ShipActor: Actor {

	let attributes: ShipAttributes

	var armor: Double
	var shield: Double
	var energy: Double
	var thrusters: Double

	init(attributes: ShipAttributes) {

		self.attributes = attributes

		armor = attributes.armor
		shield = attributes.shield
		energy = attributes.energy
		thrusters = 0.0
	}

	func update() {

		energy = min(energy * 1.002, 1.0)
	}
}
