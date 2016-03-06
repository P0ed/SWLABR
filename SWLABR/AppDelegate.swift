import Cocoa

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
	lazy var hidController = HIDController()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
		/// Init controller
		let _ = hidController
    }
}

func appDelegate() -> AppDelegate {
	return NSApplication.sharedApplication().delegate as! AppDelegate
}
