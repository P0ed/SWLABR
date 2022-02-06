import Foundation

class DeviceAction {

	let action: (Bool) -> ()

	init(_ action: @escaping (Bool) -> ()) {
		self.action = action
	}

	func performAction(_ value: Bool) {
		action(value)
	}
}

final class PressAction: DeviceAction {
	init(_ pressAction: @escaping () -> ()) {
		super.init {
			if $0 { pressAction() }
		}
	}
}
