import SpriteKit

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
        
        let title = SKShapeNode(rectOf: self.gameData.titleSize)
        title.fillColor = .white
        title.fillTexture = SKTexture(imageNamed: "title.png")
        title.position = CGPoint(x: Double(self.gameData.center.x), y: self.gameData.height - 10 - Double(self.gameData.titleSize.height * 0.5))
        self.addChild(title)
        
        let descriptionText = "Welcome to the Binary-Safe!\nThe safe you have to solve is, as you can see below, round and has columns filled with binary numbers. If you read these binary numbers inside-out, you get a binary code, which should result in the decimal on the outside. By clicking on the decimal, you get the highlight and the solution of the column. If you like a short explanation, click on the help button. Enjoy!"
        let descriptionPosition = CGPoint(x: self.gameData.center.x, y: CGFloat(self.gameData.height) - 20 - self.gameData.titleSize.height)
        let description = self.newParagraphLabel(text: descriptionText, width: CGFloat(self.gameData.width * 0.9), position: descriptionPosition)
        self.addChild(description)
        
        var helpButtonPosition: CGPoint
        var playButtonPosition: CGPoint
        var imagePosition: CGPoint
        if self.gameData.width > self.gameData.height {
            helpButtonPosition = CGPoint(x: 10 + Double(self.gameData.menuButtonSize.width * 0.5), y: self.gameData.height - 10 - Double(self.gameData.menuButtonSize.height * 0.5))
            playButtonPosition = CGPoint(x: self.gameData.width - 10 - Double(self.gameData.menuButtonSize.width * 0.5), y: self.gameData.height - 10 - Double(self.gameData.menuButtonSize.height * 0.5))
            description.fontSize = FontSize.tiny
            imagePosition = CGPoint(x: self.gameData.center.x, y: 10 + self.gameData.imageSize.height * 0.5)
        } else {
            helpButtonPosition = CGPoint(x: self.gameData.menuButtonSize.width * 0.5 + 10, y: 10 + self.gameData.menuButtonSize.height * 0.5)
            playButtonPosition = CGPoint(x: CGFloat(self.gameData.width) - 10 - self.gameData.menuButtonSize.width * 0.5, y: 10 + self.gameData.menuButtonSize.height * 0.5)
            description.fontSize = FontSize.small
            imagePosition = CGPoint(x: self.gameData.center.x, y: self.gameData.menuButtonSize.height + 20 + self.gameData.imageSize.height * 0.5)
        }
        
        let helpButton = GameControlButton(size: self.gameData.menuButtonSize, type: .help, texture: SKTexture(imageNamed: "help.png"))
        helpButton.delegate = self
        helpButton.position = helpButtonPosition
        self.addChild(helpButton)
        
        let playButton = GameControlButton(size: self.gameData.menuButtonSize, type: .play, texture: SKTexture(imageNamed: "play.png"))
        playButton.delegate = self
        playButton.position = playButtonPosition
        self.addChild(playButton)
        
        let image = SKShapeNode(rectOf: self.gameData.imageSize)
        image.fillColor = .white
        image.fillTexture = SKTexture(imageNamed: "safe_example.png")
        image.position = imagePosition
        self.addChild(image)
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
        view.presentScene(InitialScene(self.gameData))
    }
}

extension InitialScene: GameControlButtonDelegate {
    public func loadHelpScene() {
        guard let view = self.view else {
            return
        }
        view.presentScene(HelpScene(self.gameData), transition: SKTransition.crossFade(withDuration: 1))
    }
    
    public func loadGameScene() {
        guard let view = self.view else {
            return
        }
        view.presentScene(GameScene(self.gameData), transition: SKTransition.crossFade(withDuration: 0))
    }
}
