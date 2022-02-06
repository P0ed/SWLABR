import SceneKit
import SpriteKit

final class GameViewController: NSViewController {

    @IBOutlet weak var gameView: GameView!

	private var gameEngine: GameEngine!

    override func awakeFromNib() {

		gameEngine = GameEngine(renderer: gameView)

        gameView.scene = gameEngine.scene
        gameView.showsStatistics = true
		gameView.delegate = gameEngine
		gameView.isPlaying = true
		gameView.loops = true
		gameView.antialiasingMode = .none
    }
}
