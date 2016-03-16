import SceneKit

protocol ControlComponent {
	func update(node: EntityNode, inEngine engine: GameEngine)
}

protocol BehaviorComponent {
	func update(node: EntityNode, inEngine engine: GameEngine)
}

protocol CollisionComponent {
	func didBeginContact(node: EntityNode, withOtherNode other: EntityNode, contact: SCNPhysicsContact)
}

final class EntityNode: SCNNode {

	var controlComponent: ControlComponent?
	var behaviorComponent: BehaviorComponent?
	var collisionComponent: CollisionComponent?

	func update() {
		(childNodes as! [EntityNode]).forEach{ $0.update() }
	}
}
