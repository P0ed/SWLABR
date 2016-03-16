import SceneKit
import SpriteKit

final class GameEngine: NSObject, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {

	static let timeStep: Double = 1.0 / 60.0

	let scene: SCNScene
	let worldNode: EntityNode

	private var inputController: InputController

	private let shipNode: EntityNode
	private let cameraNode: SCNNode
	private let spaceParticles: SCNParticleSystem

	private var time: Double = 0.0

	init(renderer: SCNSceneRenderer) {

		scene = SpaceSceneFabric.createScene()
		worldNode = SpaceSceneFabric.createWorldNode()
		scene.rootNode.addChildNode(worldNode)

		inputController = InputController(appDelegate().hidController.eventsController)

		shipNode = SpaceSceneFabric.createPlayerShip(inputController)

		cameraNode = EntityNode()
		cameraNode.camera = SCNCamera()
		shipNode.addChildNode(cameraNode)
		cameraNode.position = Vector3(0.0, 0.6, 1.6)
		cameraNode.eulerAngles = Vector3(-0.14, 0.0, 0.0)
		renderer.audioListener = cameraNode

		spaceParticles = SpaceSceneFabric.createSpaceParticles()
		shipNode.addParticleSystem(spaceParticles)

		super.init()

		scene.physicsWorld.contactDelegate = self

		worldNode.addChildNode(shipNode)
		spawnEnemy()
	}

	func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
		if self.time != 0 {
			while time - self.time > GameEngine.timeStep {
				self.time += GameEngine.timeStep
				fixedTimeStepUpdate()
			}
		} else {
			self.time = time
		}
	}

	func renderer(renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: NSTimeInterval) {
		let body = shipNode.physicsBody!
		let velocity = body.velocity
		spaceParticles.emittingDirection = -velocity * -shipNode.presentationNode.orientation
		spaceParticles.speedFactor = velocity.length / 128.0
	}

	func physicsWorld(world: SCNPhysicsWorld, didBeginContact contact: SCNPhysicsContact) {

	}

	private func fixedTimeStepUpdate() {
		updateNode(worldNode)
		(worldNode.childNodes as! [EntityNode]).forEach(updateNode)
	}

	private func updateNode(node: EntityNode) {
		node.controlComponent?.update(node, inEngine: self)
		node.behaviorComponent?.update(node, inEngine: self)
	}

	func spawnEnemy() {
		let ship = SpaceSceneFabric.createEmptyShip()
		ship.geometry?.materials.first?.diffuse.contents = SKColor(red: 0.1, green: 0.3, blue: 0.8, alpha: 1.0)
		ship.position = Vector3(0, 0, -10)
		worldNode.addChildNode(ship)
	}
}
