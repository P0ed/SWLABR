import SceneKit
import SpriteKit
import OpenEmuSystem

final class GameViewController: NSViewController, SCNSceneRendererDelegate {

    @IBOutlet weak var gameView: GameView!

	private var shipActor: ShipActor!
	private var shipNode: SCNNode!
	private var cameraNode: SCNNode!

	private let eventsController = EventsController()
	private var eventMonitors = [UInt: AnyObject]()

	private var time: Double = 0.0
	private let timeStep: Double = 1.0 / 60.0

    override func awakeFromNib() {
        // create a new scene
        let scene = SCNScene()
		scene.physicsWorld.gravity = SCNVector3Zero
		scene.background.contents = [
			"skybox_right1",
			"skybox_left2",
			"skybox_top3",
			"skybox_bottom4",
			"skybox_front5",
			"skybox_back6"
		]

        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)

        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = NSColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)

        shipNode = createShip()
		scene.rootNode.addChildNode(shipNode)
		let attrs = ShipAttributes.fighterAttributes()
		shipActor = ShipActor(attributes: attrs, node: shipNode)

        gameView.scene = scene
//        gameView.allowsCameraControl = true
        gameView.showsStatistics = true
		gameView.delegate = self
		gameView.playing = true
		gameView.loops = true

		updateCamera(cameraNode, ship: shipNode.presentationNode)
		setupDeviceObservers()
    }

	func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {

		if self.time != 0 {
			while time - self.time > timeStep {
				self.time += timeStep
				fixedTimeStepUpdate()
			}
		} else {
			self.time = time
		}
	}

	func renderer(renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: NSTimeInterval) {
		updateCamera(cameraNode, ship: shipNode.presentationNode)
	}

	func fixedTimeStepUpdate() {
		var input = ShipInput()
		input.throttle = eventsController.leftJoystick.dy
		input.stick = StickInput(x: eventsController.rightJoystick.dx, y: eventsController.rightJoystick.dy)
		shipActor.update(input)
	}

	func createShip() -> SCNNode {
		let shipGeometry = SCNBox(width: 0.75, height: 0.25, length: 1, chamferRadius: 0)
		let material = SCNMaterial()
		material.diffuse.contents = SKColor(red: 0.8, green: 0.3, blue: 0.1, alpha: 1.0)
		shipGeometry.materials = [material]
		let node = SCNNode(geometry: shipGeometry)
		let physicsBody = SCNPhysicsBody.dynamicBody()
		physicsBody.physicsShape = SCNPhysicsShape(geometry: shipGeometry, options: nil)
		node.physicsBody = physicsBody

		return node
	}

	func updateCamera(camera: SCNNode, ship: SCNNode) {
		let cameraDistance = 2.0
		let cameraDamping = 0.3

		let shipPos = gameView.scene!.rootNode.convertPosition(ship.position, toNode: nil).vector3
		let shipOrt = ship.orientation.vector4

		print(shipPos)

		let ortDamping = double4(cameraDamping, cameraDamping, cameraDamping, cameraDamping)
//		let posDamping = double3(cameraDamping, cameraDamping, cameraDamping)

		let targetPos = double3(
			shipPos.x + cameraDistance * shipOrt.y * shipOrt.y,
			shipPos.y + cameraDistance * shipOrt.z * shipOrt.z + 0.5,
			shipPos.z + cameraDistance * shipOrt.w * shipOrt.w
		)

		let newOrt = vector_mix(camera.orientation.vector4, shipOrt, ortDamping)
//		let newPos = vector_mix(camera.position.vector3, targetPos, posDamping)

		camera.orientation = SCNQuaternion(newOrt)
		camera.position = SCNVector3(targetPos)
	}

	func setupDeviceObservers() {
		let deviceManager = OEDeviceManager.sharedDeviceManager()
		let notificationCenter = NSNotificationCenter.defaultCenter()
		let didAddDeviceKey = OEDeviceManagerDidAddDeviceHandlerNotification
		let didRemoveDeviceKey = OEDeviceManagerDidRemoveDeviceHandlerNotification

		notificationCenter.addObserverForName(didAddDeviceKey, object: nil, queue: NSOperationQueue.mainQueue()) { note in
			let deviceHandler = note.userInfo![OEDeviceManagerDeviceHandlerUserInfoKey] as! OEDeviceHandler
			self.eventMonitors[deviceHandler.deviceIdentifier] = deviceManager.addEventMonitorForDeviceHandler(deviceHandler) {
				handler, event in
				self.eventsController.handleEvent(event)
			}
		}

		notificationCenter.addObserverForName(didRemoveDeviceKey, object: nil, queue: NSOperationQueue.mainQueue()) { note in
			let deviceHandler = note.userInfo![OEDeviceManagerDeviceHandlerUserInfoKey] as! OEDeviceHandler
			self.eventMonitors.removeValueForKey(deviceHandler.deviceIdentifier)
		}
	}
}

extension SCNVector3 {
	var vector3: double3 {
		get {
			return double3(Double(x), Double(y), Double(z))
		}
	}
}

extension SCNVector4 {
	var vector4: double4 {
		get {
			return double4(Double(x), Double(y), Double(z), Double(w))
		}
	}
}
