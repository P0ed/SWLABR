import SceneKit
import SpriteKit
import OpenEmuSystem

final class GameViewController: NSViewController, SCNSceneRendererDelegate {

    @IBOutlet weak var gameView: GameView!

	private var shipActor: ShipActor!
	private var shipNode: SCNNode!
	private var cameraNode: SCNNode!
	private var particles: SCNParticleSystem!

	private let eventsController = EventsController()
	private var eventMonitors = [UInt: AnyObject]()

	private var time: Double = 0.0
	private let timeStep: Double = 1.0 / 60.0

    override func awakeFromNib() {
        gameView.scene = createScene()
        gameView.showsStatistics = true
		gameView.delegate = self
		gameView.playing = true
		gameView.loops = true
		gameView.antialiasingMode = .None

		let rootNode = gameView.scene!.rootNode

		shipNode = createShip()
		shipNode.position = SCNVector3(0, 0, 1)
		rootNode.addChildNode(shipNode)
		let attrs = ShipAttributes.fighterAttributes()
		shipActor = ShipActor(attributes: attrs, node: shipNode)

		cameraNode = SCNNode()
		cameraNode.camera = SCNCamera()
		shipNode.addChildNode(cameraNode)
		cameraNode.transform = CATransform3DMakeTranslation(0, 0.4, 1.6)

		particles = SCNParticleSystem(named: "StarsParticleSystem", inDirectory: "art.scnassets/SpaceParticles")
		particles.particleLifeSpan = 0.6
		particles.birthRate = 128
		shipNode.addParticleSystem(particles)

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

		let body = shipNode.physicsBody!
		let velocity = body.velocity
		particles.emittingDirection = -velocity * -shipNode.presentationNode.orientation
		particles.speedFactor = velocity.length / 10.0
	}

	func fixedTimeStepUpdate() {
		var input = ShipInput()
		input.throttle = eventsController.leftJoystick.dy
		input.stick = StickInput(x: eventsController.rightJoystick.dx, y: eventsController.rightJoystick.dy)
		shipActor.update(input)
	}

	func createScene() -> SCNScene {
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

		let ambientLightNode = SCNNode()
		ambientLightNode.light = SCNLight()
		ambientLightNode.light!.type = SCNLightTypeAmbient
		ambientLightNode.light!.color = NSColor.darkGrayColor()
		scene.rootNode.addChildNode(ambientLightNode)

		return scene
	}

	func createShip() -> SCNNode {
		let shipGeometry = SCNBox(width: 0.75, height: 0.25, length: 1, chamferRadius: 0)
		let material = SCNMaterial()
		material.diffuse.contents = SKColor(red: 0.8, green: 0.3, blue: 0.1, alpha: 1.0)
		shipGeometry.materials = [material]
		let node = SCNNode(geometry: shipGeometry)
		let physicsBody = SCNPhysicsBody.dynamicBody()
		physicsBody.physicsShape = SCNPhysicsShape(geometry: shipGeometry, options: nil)
		physicsBody.angularDamping = 0.9
		physicsBody.damping = 0.4
		node.physicsBody = physicsBody

		return node
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
