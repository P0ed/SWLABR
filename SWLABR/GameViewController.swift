import SceneKit
import SpriteKit

final class GameViewController: NSViewController, SCNSceneRendererDelegate {

    @IBOutlet weak var gameView: GameView!

	private var gameEngine: GameEngine!
	private var inputController: InputController!

    override func awakeFromNib() {

		gameEngine = GameEngine()
		inputController = InputController(appDelegate().hidController.eventsController)

        gameView.scene = gameEngine.scene
        gameView.showsStatistics = true
		gameView.delegate = self
		gameView.playing = true
		gameView.loops = true
		gameView.antialiasingMode = .None
    }

	func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
		gameEngine.update(time, input: inputController.currentInput())
	}

	func renderer(renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: NSTimeInterval) {
		gameEngine.didSimulatePhysics(time)
	}
}
