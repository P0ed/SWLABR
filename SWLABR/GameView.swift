import SceneKit

final class GameView: SCNView {

	func updateDrawableSize() {
		let layer = self.layer! as! CAMetalLayer
		layer.drawableSize = bounds.size
	}

	override func mouseDown(with event: NSEvent) {
        /* Called when a mouse click occurs */
        
//        // check what nodes are clicked
//        let p = self.convertPoint(theEvent.locationInWindow, fromView: nil)
//        let hitResults = self.hitTest(p, options: nil)
//        // check that we clicked on at least one object
//        if hitResults.count > 0 {
//            // retrieved the first clicked object
//            let result: AnyObject = hitResults[0]
//            
//            // get its material
//            let material = result.node!.geometry!.firstMaterial!
//            
//            // highlight it
//            SCNTransaction.begin()
//            SCNTransaction.setAnimationDuration(0.5)
//            
//            // on completion - unhighlight
//            SCNTransaction.setCompletionBlock() {
//                SCNTransaction.begin()
//                SCNTransaction.setAnimationDuration(0.5)
//                
//                material.emission.contents = NSColor.blackColor()
//                
//                SCNTransaction.commit()
//            }
//            
//            material.emission.contents = NSColor.redColor()
//            
//            SCNTransaction.commit()
//        }

		super.mouseDown(with: event)
    }
}
