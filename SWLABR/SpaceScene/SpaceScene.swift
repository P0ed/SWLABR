import SceneKit
import SpriteKit

final class SpaceSceneFabric {

	static func createScene() -> SCNScene {
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

	static func createEmptyShip() -> EntityNode {
		let shipGeometry = SCNBox(width: 0.75, height: 0.25, length: 1, chamferRadius: 0)
		let material = SCNMaterial()
		material.diffuse.contents = SKColor(red: 0.8, green: 0.3, blue: 0.1, alpha: 1.0)
		shipGeometry.materials = [material]

		let node = EntityNode()
		node.geometry = shipGeometry

		let physicsBody = SCNPhysicsBody.dynamicBody()
		physicsBody.physicsShape = SCNPhysicsShape(geometry: shipGeometry, options: nil)
		physicsBody.angularDamping = 0.9
		physicsBody.damping = 0.4
		node.physicsBody = physicsBody

		return node
	}

	static func createPlayerShip(inputController: InputController) -> EntityNode {
		let inputComponent = InputComponent(inputController)
		let behavior = ShipBehavior(attributes: ShipAttributes.fighterAttributes())

		let node = createEmptyShip()
		node.controlComponent = inputComponent
		node.behaviorComponent = behavior

		return node
	}

	static func createSpaceParticles() -> SCNParticleSystem {
		let particles = SCNParticleSystem(
			named: "StarsParticleSystem",
			inDirectory: "art.scnassets/SpaceParticles"
			)!
		particles.particleLifeSpan = 0.6
		particles.birthRate = 128
		return particles
	}

	static func createBlasterNode() -> EntityNode {
		let geometry = SCNBox(width: 0.08, height: 0.08, length: 0.8, chamferRadius: 0.0)
		let material = SCNMaterial()
		material.diffuse.contents = SKColor(red: 0.1, green: 0.8, blue: 0.4, alpha: 1.0)

		let physicsBody = SCNPhysicsBody.dynamicBody()
		physicsBody.physicsShape = SCNPhysicsShape(geometry: geometry, options: nil)
		physicsBody.mass = 0.01
		physicsBody.damping = 0.0
		physicsBody.angularDamping = 0.0

		let node = EntityNode()
		node.geometry = geometry
		node.geometry?.materials = [material]
		node.physicsBody = physicsBody
		return node
	}
}
