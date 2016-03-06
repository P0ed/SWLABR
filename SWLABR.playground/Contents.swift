import Cocoa
import SceneKit
import XCPlayground

// Set up a scene for our tests
let scene = SCNScene()
let view = SCNView(frame: NSRect(x: 0, y: 0, width: 500, height: 500))
view.autoenablesDefaultLighting = true
view.scene = scene
let cameraNode = SCNNode()
cameraNode.camera = SCNCamera()
cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
scene.rootNode.addChildNode(cameraNode)

XCPlaygroundPage.currentPage.liveView = view

// Make a pyramid to test on
let node = SCNNode(geometry: SCNPyramid(width: 1, height: 1, length: 1))
scene.rootNode.addChildNode(node)
node.physicsBody = SCNPhysicsBody.dynamicBody()
scene.physicsWorld.gravity = SCNVector3Zero // Don't fall off screen

// Rotate around the axis that looks into the screen
node.physicsBody?.applyTorque(SCNVector4(x: 0, y: 0, z: 1, w: 0.1), impulse: true)

// Wait a bit, then try to rotate around the y-axis
node.runAction(SCNAction.waitForDuration(10), completionHandler: {
	var axis = SCNVector3(x: 0, y: 1, z: 0)
	node.physicsBody?.applyTorque(SCNVector4(x: axis.x, y: axis.y, z: axis.z, w: 1), impulse: true)
})
