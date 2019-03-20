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
        
        let title = SKShapeNode(rectOf: CGSize(width: self.gameData.width * 0.9, height: self.gameData.width * 0.18))
        title.fillColor = .white
        title.fillTexture = SKTexture(imageNamed: "title.png")
        title.position = CGPoint(x: Double(self.gameData.center.x), y: self.gameData.height - 10 - self.gameData.width * 0.09)
        self.addChild(title)
        
        let descriptionText = "Welcome to the Binary-Safe!\nYour goal is to turn the layers of the Safe, so the binary-code of each column(!written from inside to outside!) results the decimal number on the outside. If you need help with the convertion from binary to decimal, you can view a short explanation on the \"Help\" button or click on the number outside of a column to view the solution of this column. Enjoy!"
        let descriptionPosition = CGPoint(x: Double(self.gameData.center.x), y: self.gameData.height - 20 - self.gameData.width * 0.18)
        let description = self.newParagraphLabel(text: descriptionText, width: CGFloat(self.gameData.width * 0.9), position: descriptionPosition)
        self.addChild(description)
        
        let helpButton = GameControlButton(size: self.gameData.menuButtonSize, type: .help, texture: SKTexture(imageNamed: "help.png"))
        helpButton.delegate = self
        helpButton.position = CGPoint(x: self.gameData.menuButtonSize.width * 0.5 + 10, y: 10 + self.gameData.menuButtonSize.height * 0.5)
        self.addChild(helpButton)
        
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
        view.presentScene(GameScene(self.gameData), transition: SKTransition.crossFade(withDuration: 1))
    }
}
