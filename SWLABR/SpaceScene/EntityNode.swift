import SceneKit

protocol ControlComponent {
	func update(node: EntityNode)
}

protocol BehaviorComponent {
	func update(node: EntityNode)
}

protocol CollisionComponent {
	func didBeginContact(node: EntityNode, withOtherNode other: EntityNode, contact: SCNPhysicsContact)
}

final class EntityNode: SCNNode {

	var controlComponent: ControlComponent?
	var behaviorComponent: BehaviorComponent?
	var collisionComponent: CollisionComponent?
}
