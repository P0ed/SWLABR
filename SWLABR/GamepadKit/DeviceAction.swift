import Foundation

class DeviceAction {

	let action: (Bool) -> ()

	init(_ action: (Bool) -> ()) {
		self.action = action
	}

	func performAction(value: Bool) {
		action(value)
	}
}

class PressAction: DeviceAction {
	init(_ pressAction: () -> ()) {
		super.init {
			if $0 { pressAction() }
		}
	}
}
