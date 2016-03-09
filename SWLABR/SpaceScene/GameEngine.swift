import SceneKit
import SpriteKit

final class GameEngine: NSObject, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {

	let scene: SCNScene

	static let timeStep: Double = 1.0 / 60.0

	private var inputController: InputController

	private var nodes: [EntityNode] = []

	private let shipNode: EntityNode
	private let cameraNode: SCNNode
	private let spaceParticles: SCNParticleSystem

	private var time: Double = 0.0

	override init() {
		scene = SpaceSceneFabric.createScene()

		inputController = InputController(appDelegate().hidController.eventsController)

		shipNode = SpaceSceneFabric.createPlayerShip(inputController)
		scene.rootNode.addChildNode(shipNode)

		cameraNode = SCNNode()
		cameraNode.camera = SCNCamera()
		shipNode.addChildNode(cameraNode)
		cameraNode.position = Vector3(0.0, 0.6, 1.6)
		cameraNode.eulerAngles = Vector3(-0.14, 0.0, 0.0)

		spaceParticles = SpaceSceneFabric.createSpaceParticles()
		shipNode.addParticleSystem(spaceParticles)

		nodes = [shipNode]

		super.init()

		scene.physicsWorld.contactDelegate = self

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
		nodes.forEach(updateNode)
	}

	private func updateNode(node: EntityNode) {
		node.controlComponent?.update(node)
		node.behaviorComponent?.update(node)
	}

	func spawnEnemy() {
		let ship = SpaceSceneFabric.createEmptyShip()
		ship.geometry?.materials.first?.diffuse.contents = SKColor(red: 0.1, green: 0.3, blue: 0.8, alpha: 1.0)
		ship.position = Vector3(0, 0, 10)
		scene.rootNode.addChildNode(ship)
	}
}
