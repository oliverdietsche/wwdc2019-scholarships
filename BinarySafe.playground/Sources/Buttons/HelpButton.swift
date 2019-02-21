import SpriteKit

class HelpButton: SKSpriteNode {
    public var delegate: HelpButtonDelegate?
    private let column: Int
    private var isSelected: Bool
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(size: CGSize, text: String, column: Int, degree: Double) {
        self.column = column
        self.isSelected = false
        
        super.init(texture: nil, color: SKColor.blue, size: size)
        
        let label = SKLabelNode(fontNamed: "Arial")
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.fontSize = size.width
        label.fontColor = UIColor.black
        label.text = text
        self.addChild(label)
        
        if 90 < degree && degree < 270 {
            label.horizontalAlignmentMode = .right
        }
        
        self.color = .clear
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
            
            delegate.displayHelp(column: column)
        }
    }
}
