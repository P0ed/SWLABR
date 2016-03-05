import Foundation

class ShipActor: Actor {

	let attributes: ShipAttributes

	var armor: Double = 0.0
	var shield: Double = 0.0
	var energy: Double = 0.0

	init(attributes: ShipAttributes) {

		self.attributes = attributes
	}
}
