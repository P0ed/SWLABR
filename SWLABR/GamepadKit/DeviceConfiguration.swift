import Foundation
import OpenEmuSystem

struct DeviceConfiguration {

	var buttonsMapTable: [DSButton: DeviceAction]
	var dPadMapTable: [DSHatDirection: DeviceAction]
	var keyboardMapTable: [Int: DeviceAction]

	static func keyCodeForVirtualKey(virtualKey: Int) -> Int {
		return Int(OEHIDEvent.keyCodeForVirtualKey(CGCharCode(virtualKey)))
	}
}
