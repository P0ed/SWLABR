import Foundation

struct DSVector {
	var dx: Double
	var dy: Double

	static let zeroVector = DSVector(dx: 0.0, dy: 0.0)
}

enum DSButton: Int {
	case Square = 1
	case Cross = 2
	case Circle = 3
	case Triangle = 4
	case L1 = 5
	case R1 = 6
	case L2 = 7
	case R2 = 8
	case Share = 9
	case Options = 10
}

enum DSStick {
	case Left
	case Right
}

enum DSTrigger {
	case Left
	case Right
}

enum DSHatDirection: Int {
	case Null		= 0
	case Up			= 1
	case Right		= 2
	case Down		= 4
	case Left		= 8
	case UpRight	= 3
	case DownRight	= 6
	case UpLeft		= 9
	case DownLeft	= 12
}

enum DSControl {
	case Button(DSButton)
	case Stick(DSStick)
	case Trigger(DSTrigger)
	case DPad(DSHatDirection)
}
