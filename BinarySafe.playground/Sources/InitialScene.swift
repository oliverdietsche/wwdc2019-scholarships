import PlaygroundSupport
import SpriteKit
import Foundation

public class InitialScene: SKScene {
    
    var gameData: GameData
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    public init(_ gameData: GameData) {
        self.gameData = gameData
        super.init(size: CGSize(width: gameData.width, height: gameData.height))
    }
    
    public override func didMove(to view: SKView) {
        self.backgroundColor = .white
        
        let helpButton = HelpButton(size: CGSize(width: 40, height: 40), text: "001", column: 0, degree: 0)
        helpButton.delegate = self
        helpButton.position = CGPoint(x: self.gameData.center.x, y: self.gameData.center.y + 100)
        self.addChild(helpButton)
        
        let playButton = SKButton(size: CGSize(width: 100, height: 100), type: .play, texture: SKTexture(imageNamed: "weirdo.png"))
        playButton.delegate = self
        playButton.position = CGPoint(x: self.gameData.center.x, y: self.gameData.center.y - 100)
        self.addChild(playButton)
    }
}

extension InitialScene: SKButtonDelegate, HelpButtonDelegate {
    public func displayHelp(column: Int) {
        print("display help")
    }
    
    public func loadGameScene() {
        guard let view = self.view else {
            return
        }
        view.presentScene(GameScene(self.gameData), transition: SKTransition.crossFade(withDuration: 1))
    }
    
    public func shuffleLayers() {
        fatalError("Not supported in InitialScene")
    }
    
    public func loadHomeScene() {
        fatalError("Not supported in InitialScene")
    }
    
    public func solveLayers() {
        fatalError("Not supported in InitialScene")
    }
}
