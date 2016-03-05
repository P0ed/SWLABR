import Foundation

struct ShipAttributes {

	let armor: Double
	let shield: Double
	let energy: Double

	let topSpeed: Double
	let turnRate: Double
}

extension ShipAttributes {

	static func fighterAttributes() -> ShipAttributes {
		return ShipAttributes(
			armor: 200,
			shield: 320,
			energy: 480,
			topSpeed: 180,
			turnRate: 40
		)
	}
}
