import SceneKit
import SpriteKit

final class SpaceScene {

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

	static func createShip() -> SCNNode {
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
}
