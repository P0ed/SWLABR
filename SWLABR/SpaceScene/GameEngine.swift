import SceneKit
import SpriteKit

final class GameEngine {

	let scene: SCNScene

	private let shipActor: ShipActor
	private let cameraNode: SCNNode
	private let spaceParticles: SCNParticleSystem

	private var time: Double = 0.0
	private let timeStep: Double = 1.0 / 60.0

	init() {
		scene = SpaceSceneFabric.createScene()

		let shipNode = SpaceSceneFabric.createShip()
		scene.rootNode.addChildNode(shipNode)
		let attrs = ShipAttributes.fighterAttributes()
		shipActor = ShipActor(attributes: attrs, node: shipNode)

		cameraNode = SCNNode()
		cameraNode.camera = SCNCamera()
		shipNode.addChildNode(cameraNode)
		cameraNode.position = Vector3(0.0, 0.6, 1.6)
		cameraNode.eulerAngles = Vector3(-0.16, 0.0, 0.0)

		spaceParticles = SpaceSceneFabric.createSpaceParticles()
		shipNode.addParticleSystem(spaceParticles)

		spawnEnemy()
	}

	func update(time: NSTimeInterval, input: ShipInput) {
		if self.time != 0 {
			while time - self.time > timeStep {
				self.time += timeStep
				fixedTimeStepUpdate(input)
			}
		} else {
			self.time = time
		}
	}

	private func fixedTimeStepUpdate(input: ShipInput) {
		shipActor.update(input)
	}

	func didSimulatePhysics(time: NSTimeInterval) {
		let body = shipActor.node.physicsBody!
		let velocity = body.velocity
		spaceParticles.emittingDirection = -velocity * -shipActor.node.presentationNode.orientation
		spaceParticles.speedFactor = velocity.length / 10.0
	}

	func spawnEnemy() {
		let ship = SpaceSceneFabric.createShip()
		ship.geometry?.materials.first?.diffuse.contents = SKColor(red: 0.1, green: 0.3, blue: 0.8, alpha: 1.0)
		ship.position = Vector3(0, 0, 10)
		scene.rootNode.addChildNode(ship)
	}
}
