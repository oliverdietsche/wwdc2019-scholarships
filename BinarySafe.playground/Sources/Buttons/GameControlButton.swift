import SpriteKit

class GameControlButton: SKSpriteNode {
    enum ButtonType {
        case play, shuffle, home, solve
    }
    public var delegate: GameControlButtonDelegate?
    private var isSelected: Bool
    private let type: ButtonType
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(size: CGSize, type: ButtonType, texture: SKTexture) {
        self.type = type
        self.isSelected = false
        
        super.init(texture: texture, color: SKColor.blue, size: size)
        
        self.isUserInteractionEnabled = true
        self.zPosition = 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isSelected = true
        self.scale(to: CGSize(width: self.size.width * 0.9, height: self.size.height * 0.9))
        self.alpha = 0.6
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let parent = self.parent else {
            return
        }
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: parent)
        
        if (self.frame.contains(touchLocation)) {
            self.isSelected = true
        } else {
            self.isSelected = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.scale(to: CGSize(width: self.size.width / 0.9, height: self.size.height / 0.9))
        self.alpha = 1
        
        if isSelected {
            guard let delegate = self.delegate else {
                return
            }
            
            switch self.type {
            case .play:
                delegate.loadGameScene?()
            case .shuffle:
                delegate.shuffleLayers?()
            case .home:
                delegate.loadHomeScene?()
            case .solve:
                delegate.solveLayers?()
            }
        }
    }
}
