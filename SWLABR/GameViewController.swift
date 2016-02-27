import SceneKit
import QuartzCore

class GameViewController: NSViewController {
    
    @IBOutlet weak var gameView: GameView!
    
    override func awakeFromNib() {
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/Light Ship/light_ship.scn")!
		scene.background.contents = [
			"skybox_right1",
			"skybox_left2",
			"skybox_top3",
			"skybox_bottom4",
			"skybox_front5",
			"skybox_back6"
		]
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = NSColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
        let _ = scene.rootNode.childNodeWithName("ship", recursively: true)!

        // set the scene to the view
        self.gameView.scene = scene
        
        // allows the user to manipulate the camera
        self.gameView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        self.gameView.showsStatistics = true
        
        // configure the view
        self.gameView.backgroundColor = NSColor.blackColor()

    }

}
