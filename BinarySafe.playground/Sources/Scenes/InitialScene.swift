import PlaygroundSupport
import SpriteKit
import Foundation
import UIKit

public class InitialScene: SKScene {
    
    private var gameData: GameData
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    public init(_ gameData: GameData) {
        self.gameData = gameData
        super.init(size: CGSize(width: gameData.width, height: gameData.height))
    }
    
    public override func didChangeSize(_ oldSize: CGSize) {
        self.gameData.width = Double(self.size.width)
        self.gameData.height = Double(self.size.height)
        self.reloadScene()
    }
    
    public override func didMove(to view: SKView) {
        self.backgroundColor = .white
        
        let playButton = GameControlButton(size: CGSize(width: 150, height: 50), type: .play, texture: SKTexture(imageNamed: "play.png"))
        playButton.delegate = self
        playButton.position = CGPoint(x: self.gameData.center.x, y: 35)
        self.addChild(playButton)
    }
    
    // MARK: private
    
    private func reloadScene() {
        guard let view = self.view else {
            return
        }
        view.presentScene(InitialScene(self.gameData))
    }
}

extension InitialScene: GameControlButtonDelegate {
    public func loadGameScene() {
        guard let view = self.view else {
            return
        }
        view.presentScene(GameScene(self.gameData), transition: SKTransition.crossFade(withDuration: 1))
    }
}
