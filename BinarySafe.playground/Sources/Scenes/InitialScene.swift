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
        
        let descriptionText = "Welcome to the Binary-Safe!\nThe safe you have to solve consists of different layers and sections containing binary values. Rotate the layers until the binary code, read from the inside to the outside, results in the decimal shown on the outside of the safe.\nYou can check the current value of each section by pressing on the decimal and increase the difficulty by clicking on the home button to adjust the amount of layers and pieces. Choose help if you need further explanation. Enjoy!"
        let descriptionPosition = CGPoint(x: self.gameData.center.x, y: CGFloat(self.gameData.height) - 20 - self.gameData.titleSize.height)
        let description = self.newParagraphLabel(text: descriptionText, width: CGFloat(self.gameData.width) - 20, position: descriptionPosition)
        self.addChild(description)
        
        var helpButtonPosition: CGPoint
        var playButtonPosition: CGPoint
        var imageHeight: CGFloat
        if self.gameData.width > self.gameData.height {
            helpButtonPosition = CGPoint(x: 10 + Double(self.gameData.menuButtonSize.width * 0.5), y: self.gameData.height - 10 - Double(self.gameData.menuButtonSize.height * 0.5))
            playButtonPosition = CGPoint(x: self.gameData.width - 10 - Double(self.gameData.menuButtonSize.width * 0.5), y: self.gameData.height - 10 - Double(self.gameData.menuButtonSize.height * 0.5))
            description.fontSize = FontSize.tiny
            imageHeight = CGFloat(self.gameData.height) - 40 - self.gameData.titleSize.height - description.frame.height
        } else {
            helpButtonPosition = CGPoint(x: self.gameData.menuButtonSize.width * 0.5 + 10, y: 10 + self.gameData.menuButtonSize.height * 0.5)
            playButtonPosition = CGPoint(x: CGFloat(self.gameData.width) - 10 - self.gameData.menuButtonSize.width * 0.5, y: 10 + self.gameData.menuButtonSize.height * 0.5)
            description.fontSize = FontSize.small
            imageHeight = CGFloat(self.gameData.height) - 50 - self.gameData.menuButtonSize.height - self.gameData.titleSize.height - description.frame.height
        }
        
        let helpButton = GameControlButton(size: self.gameData.menuButtonSize, type: .help, texture: SKTexture(imageNamed: "help.png"))
        helpButton.delegate = self
        helpButton.position = helpButtonPosition
        self.addChild(helpButton)
        
        let playButton = GameControlButton(size: self.gameData.menuButtonSize, type: .play, texture: SKTexture(imageNamed: "play.png"))
        playButton.delegate = self
        playButton.position = playButtonPosition
        self.addChild(playButton)
        
        let imageWidth = imageHeight * 0.8125
        let image = SKShapeNode(rectOf: CGSize(width: imageWidth, height: imageHeight))
        image.fillColor = .white
        image.fillTexture = SKTexture(imageNamed: "safe_example.png")
        image.position = CGPoint(x: self.gameData.center.x, y: CGFloat(self.gameData.height) - imageHeight * 0.5 - self.gameData.titleSize.height - description.frame.height - 30)
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
