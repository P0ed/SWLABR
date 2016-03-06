import Foundation
import OpenEmuSystem

class HIDController {

	let eventsController = EventsController()
	private var eventMonitors: [UInt: AnyObject] = [:]

	init() {
		let deviceManager = OEDeviceManager.sharedDeviceManager()
		let notificationCenter = NSNotificationCenter.defaultCenter()
		let didAddDeviceKey = OEDeviceManagerDidAddDeviceHandlerNotification
		let didRemoveDeviceKey = OEDeviceManagerDidRemoveDeviceHandlerNotification

		notificationCenter.addObserverForName(didAddDeviceKey, object: nil, queue: NSOperationQueue.mainQueue()) { [unowned self] note in
			let deviceHandler = note.userInfo![OEDeviceManagerDeviceHandlerUserInfoKey] as! OEDeviceHandler
			self.eventMonitors[deviceHandler.deviceIdentifier] = deviceManager.addEventMonitorForDeviceHandler(deviceHandler) {
				handler, event in
				self.eventsController.handleEvent(event)
			}
		}

		notificationCenter.addObserverForName(didRemoveDeviceKey, object: nil, queue: NSOperationQueue.mainQueue()) { [unowned self] note in
			let deviceHandler = note.userInfo![OEDeviceManagerDeviceHandlerUserInfoKey] as! OEDeviceHandler
			self.eventMonitors.removeValueForKey(deviceHandler.deviceIdentifier)
		}
	}
}
