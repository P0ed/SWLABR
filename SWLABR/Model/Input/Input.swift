import Foundation

struct StickInput {
	var x: Double
	var y: Double
}

struct ShipInput {
	var fireBlaster: Bool = false
	var fireTorpedo: Bool = false
	var throttle: Double = 0.0
	var stick: StickInput = StickInput(x: 0.0, y: 0.0)
}
