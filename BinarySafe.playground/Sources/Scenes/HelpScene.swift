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
        
        let title = SKShapeNode(rectOf: self.gameData.titleSize)
        title.fillColor = .white
        title.fillTexture = SKTexture(imageNamed: "title.png")
        title.position = CGPoint(x: Double(self.gameData.center.x), y: self.gameData.height - 10 - Double(self.gameData.titleSize.height * 0.5))
        self.addChild(title)
        
        let descriptionText = "When it comes to calculating between decimal and binary, there are multiple ways to do so. I think the most common one is to imagine oneself a grid with numbers.\n\nThis grid starts with 1 at the very right and the number gets always doubled and written down further left of the start(..., 8, 4, 2 ,1). Once you’ve got as many as the binary code has numbers, you can place the binary code underneath your calculated numbers. Now add all your calculated numbers with a 1 beneath itself and you’ll get the decimal number.\n\nTo get the binary from decimal, you just have to draw the same grid and split the number in as few parts as possible."
        let descriptionPosition = CGPoint(x: Double(self.gameData.center.x), y: self.gameData.height - 20 - Double(self.gameData.titleSize.height))
        let description = self.newParagraphLabel(text: descriptionText, width: CGFloat(self.gameData.width * 0.9), position: descriptionPosition)
        self.addChild(description)
        
        var imagePosition: CGPoint
        var playButtonPosition: CGPoint
        if self.gameData.width > self.gameData.height {
            imagePosition = CGPoint(x: 10 + Double(self.gameData.menuButtonSize.width * 0.5), y: self.gameData.height - 10 - Double(self.gameData.menuButtonSize.height * 0.5))
            playButtonPosition = CGPoint(x: self.gameData.width - 10 - Double(self.gameData.menuButtonSize.width * 0.5), y: self.gameData.height - 10 - Double(self.gameData.menuButtonSize.height * 0.5))
            description.fontSize = FontSize.tiny
        } else {
            imagePosition = CGPoint(x: self.gameData.menuButtonSize.width * 0.5 + 10, y: 10 + self.gameData.menuButtonSize.height * 0.5)
            playButtonPosition = CGPoint(x: CGFloat(self.gameData.width) - 10 - self.gameData.menuButtonSize.width * 0.5, y: 10 + self.gameData.menuButtonSize.height * 0.5)
            description.fontSize = FontSize.small
        }
        
        let image = SKShapeNode(rectOf: self.gameData.menuButtonSize)
        image.fillColor = .white
        image.fillTexture = SKTexture(imageNamed: "100binary_example.png")
        image.position = imagePosition
        self.addChild(image)
        
        let playButton = GameControlButton(size: self.gameData.menuButtonSize, type: .play, texture: SKTexture(imageNamed: "play.png"))
        playButton.delegate = self
        playButton.position = playButtonPosition
        self.addChild(playButton)
    }
    
    // MARK: private
    
    private func newParagraphLabel(text: String, width: CGFloat, position: CGPoint) -> SKLabelNode {
        let label = SKLabelNode(fontNamed: "Arial")
        label.fontSize = FontSize.small
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
        view.presentScene(GameScene(self.gameData), transition: SKTransition.crossFade(withDuration: 0))
    }
}
