import SceneKit
import SpriteKit

class GameViewController: NSViewController, SCNSceneRendererDelegate {
    
    @IBOutlet weak var gameView: GameView!

	var shipNode: SCNNode!
	var cameraNode: SCNNode!
    
    override func awakeFromNib() {
        // create a new scene
        let scene = SCNScene()
		scene.background.contents = [
			"skybox_right1",
			"skybox_left2",
			"skybox_top3",
			"skybox_bottom4",
			"skybox_front5",
			"skybox_back6"
		]
        
        // create and add a camera to the scene
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = NSColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)

        // retrieve the ship node

        shipNode = createShip()
		scene.rootNode.addChildNode(shipNode)

		updateCamera(cameraNode, ship: shipNode)

        // set the scene to the view
        gameView.scene = scene
//        gameView.allowsCameraControl = true
        gameView.showsStatistics = true
		gameView.delegate = self
		gameView.playing = true
		gameView.loops = true
    }

	func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
		updateCamera(cameraNode, ship: shipNode)
	}

	func createShip() -> SCNNode {
		let shipGeometry = SCNBox(width: 0.75, height: 0.25, length: 1, chamferRadius: 0)
		let material = SCNMaterial()
		material.diffuse.contents = SKColor(red: 0.8, green: 0.3, blue: 0.1, alpha: 1.0)
		shipGeometry.materials = [material]
		return SCNNode(geometry: shipGeometry)
	}

	func updateCamera(camera: SCNNode, ship: SCNNode) {
		let cameraDistance = 2.0
		let cameraDamping = 0.125

		let shipPos = ship.position.vector3
		let shipOrt = ship.orientation.vector4

		let ortDamping = double4(cameraDamping, cameraDamping, cameraDamping, cameraDamping)
		let posDamping = double3(cameraDamping, cameraDamping, cameraDamping)

		let targetPos = double3(
			shipPos.x + cameraDistance * shipOrt.y * shipOrt.y,
			shipPos.y + cameraDistance * shipOrt.z * shipOrt.z,
			shipPos.z + cameraDistance * shipOrt.w * shipOrt.w
		)

		let newOrt = vector_mix(camera.orientation.vector4, shipOrt, ortDamping)
		let newPos = vector_mix(camera.position.vector3, targetPos, posDamping)

		camera.orientation = SCNQuaternion(newOrt)
		camera.position = SCNVector3(newPos)
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
