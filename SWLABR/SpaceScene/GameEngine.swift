import SceneKit

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
		cameraNode.transform = CATransform3DMakeTranslation(0, 0.4, 1.6)

		spaceParticles = SpaceSceneFabric.createSpaceParticles()
		shipNode.addParticleSystem(spaceParticles)
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
}
