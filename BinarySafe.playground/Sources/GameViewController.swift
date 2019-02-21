import UIKit
import SpriteKit

public class GameViewController: UIViewController {
    
    public override func loadView() {
        self.view = SKView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.view as? SKView else {
            return
        }
        
        let gameData = GameData()
        let initialScene = InitialScene(gameData)
        view.presentScene(initialScene)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        (self.view as? SKView)?.scene?.size = self.view.bounds.size
    }
}
