import SceneKit
import SpriteKit
import OpenEmuSystem

final class GameViewController: NSViewController, SCNSceneRendererDelegate {

    @IBOutlet weak var gameView: GameView!

	private var inputController: InputController!

	private var shipActor: ShipActor!
	private var shipNode: SCNNode!
	private var cameraNode: SCNNode!
	private var particles: SCNParticleSystem!

	private var time: Double = 0.0
	private let timeStep: Double = 1.0 / 60.0

    override func awakeFromNib() {
        gameView.scene = SpaceScene.createScene()
        gameView.showsStatistics = true
		gameView.delegate = self
		gameView.playing = true
		gameView.loops = true
		gameView.antialiasingMode = .None

		inputController = InputController(appDelegate().hidController.eventsController)

		let rootNode = gameView.scene!.rootNode

		shipNode = SpaceScene.createShip()
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
		shipActor.update(inputController.currentInput())
	}
}
