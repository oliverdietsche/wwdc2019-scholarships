import SpriteKit

public class HelpScene: SKScene {
    
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
        
        let title = SKShapeNode(rectOf: CGSize(width: self.gameData.width * 0.9, height: self.gameData.width * 0.18))
        title.fillColor = .white
        title.fillTexture = SKTexture(imageNamed: "title.png")
        title.position = CGPoint(x: Double(self.gameData.center.x), y: self.gameData.height - 10 - self.gameData.width * 0.09)
        self.addChild(title)
        
        let descriptionText = "That's how you can calculate binary code!"
        let description = self.newParagraphLabel(text: descriptionText, width: CGFloat(self.gameData.width * 0.9), position: CGPoint(x: Double(self.gameData.center.x), y: self.gameData.height - 20 - self.gameData.width * 0.18))
        self.addChild(description)
        
        let image = SKShapeNode(rectOf: self.gameData.menuButtonSize)
        image.fillColor = .white
        image.fillTexture = SKTexture(imageNamed: "100binary_example.png")
        image.position = CGPoint(x: self.gameData.menuButtonSize.width * 0.5 + 10, y: 10 + self.gameData.menuButtonSize.height * 0.5)
        self.addChild(image)
        
        let playButton = GameControlButton(size: self.gameData.menuButtonSize, type: .play, texture: SKTexture(imageNamed: "play.png"))
        playButton.delegate = self
        playButton.position = CGPoint(x: CGFloat(self.gameData.width) - 10 - self.gameData.menuButtonSize.width * 0.5, y: 10 + self.gameData.menuButtonSize.height * 0.5)
        self.addChild(playButton)
    }
    
    // MARK: private
    
    private func newParagraphLabel(text: String, width: CGFloat, position: CGPoint) -> SKLabelNode {
        let label = SKLabelNode(fontNamed: "Arial")
        label.fontSize = self.gameData.fontSize_s
        label.fontColor = UIColor.black
        label.verticalAlignmentMode = .top
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = width
        label.position = position
        label.text = text
        return label
    }
    
    private func reloadScene() {
        guard let view = self.view else {
            return
        }
        view.presentScene(HelpScene(self.gameData))
    }
}

extension HelpScene: GameControlButtonDelegate {
    public func loadGameScene() {
        guard let view = self.view else {
            return
        }
        view.presentScene(GameScene(self.gameData), transition: SKTransition.crossFade(withDuration: 1))
    }
}
