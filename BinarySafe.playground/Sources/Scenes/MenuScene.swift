import PlaygroundSupport
import SpriteKit
import UIKit

public class MenuScene: SKScene {
    
    private var gameData: GameData
    private var isViewChanged: Bool
    
    private var layersLabel: UILabel?
    private var piecesLabel: UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    public init(_ gameData: GameData) {
        self.gameData = gameData
        self.isViewChanged = false
        super.init(size: CGSize(width: gameData.width, height: gameData.height))
    }
    
    public override func didChangeSize(_ oldSize: CGSize) {
        if !self.isViewChanged {
            self.gameData.width = Double(self.size.width)
            self.gameData.height = Double(self.size.height)
            self.reloadScene()
        }
    }
    
    public override func didMove(to view: SKView) {
        self.backgroundColor = .white
        
        let title = SKShapeNode(rectOf: CGSize(width: self.gameData.width * 0.9, height: self.gameData.width * 0.18))
        title.fillColor = .white
        title.fillTexture = SKTexture(imageNamed: "title.png")
        title.position = CGPoint(x: Double(self.gameData.center.x), y: self.gameData.height - 10 - self.gameData.width * 0.09)
        self.addChild(title)
        
        let itemSize = CGSize(width: self.gameData.width * 0.6, height: Double(self.gameData.gameButtonLength))
        
        let layersLabel_frame = CGRect(origin: CGPoint(x: self.gameData.width * 0.2, y: Double(self.gameData.gameButtonLength * 2)), size: itemSize)
        let layersLabel = UILabel(frame: layersLabel_frame)
        layersLabel.textAlignment = .center
        layersLabel.text = "Layers: \(self.gameData.layers)"
        view.addSubview(layersLabel)
        self.layersLabel = layersLabel
        
        let layersSlider_frame = CGRect(origin: CGPoint(x: self.gameData.width * 0.2, y: Double(self.gameData.gameButtonLength * 2.5)), size: itemSize)
        let layersSlider = self.newSlider(frame: layersSlider_frame, minValue: 2, maxValue: 6, value: Float(self.gameData.layers))
        layersSlider.addTarget(self, action: #selector(changeLayersValue(_:)), for: .valueChanged)
        view.addSubview(layersSlider)
        
        let piecesLabel_frame = CGRect(origin: CGPoint(x: self.gameData.width * 0.2, y: Double(self.gameData.gameButtonLength * 3.5)), size: itemSize)
        let piecesLabel = UILabel(frame: piecesLabel_frame)
        piecesLabel.textAlignment = .center
        piecesLabel.text = "Pieces: \(self.gameData.pieces)"
        view.addSubview(piecesLabel)
        self.piecesLabel = piecesLabel
        
        let piecesSlider_frame = CGRect(origin: CGPoint(x: self.gameData.width * 0.2, y: Double(self.gameData.gameButtonLength * 4)), size: itemSize)
        let piecesSlider = self.newSlider(frame: piecesSlider_frame, minValue: 3, maxValue: 10, value: Float(self.gameData.pieces))
        piecesSlider.addTarget(self, action: #selector(changePiecesValue(_:)), for: .valueChanged)
        view.addSubview(piecesSlider)
        
        let helpButton = GameControlButton(size: self.gameData.menuButtonSize, type: .help, texture: SKTexture(imageNamed: "help"))
        helpButton.delegate = self
        helpButton.position = CGPoint(x: self.gameData.menuButtonSize.width * 0.5 + 10, y: 10 + self.gameData.menuButtonSize.height * 0.5)
        self.addChild(helpButton)
        
        let playButton = GameControlButton(size: self.gameData.menuButtonSize, type: .play, texture: SKTexture(imageNamed: "play.png"))
        playButton.delegate = self
        playButton.position = CGPoint(x: CGFloat(self.gameData.width) - 10 - self.gameData.menuButtonSize.width * 0.5, y: 10 + self.gameData.menuButtonSize.height * 0.5)
        self.addChild(playButton)
    }
    
    @objc func changeLayersValue(_ sender: UISlider) {
        guard let layersLabel = self.layersLabel else {
            return
        }
        self.gameData.layers = Int(sender.value)
        layersLabel.text = "Layers: \(self.gameData.layers)"
    }
    
    @objc func changePiecesValue(_ sender: UISlider) {
        guard let piecesLabel = self.piecesLabel else {
            return
        }
        self.gameData.pieces = Int(sender.value)
        piecesLabel.text = "Pieces: \(self.gameData.pieces)"
    }
    
    // MARK: private
    
    private func newSlider(frame: CGRect, minValue: Float, maxValue: Float, value: Float) -> UISlider {
        let slider = UISlider(frame: frame)
        slider.minimumValue = minValue
        slider.maximumValue = maxValue
        slider.setValue(value, animated: false)
        return slider
    }
    
    private func reloadScene() {
        guard let view = self.view else {
            return
        }
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.presentScene(MenuScene(self.gameData))
    }
}

extension MenuScene: GameControlButtonDelegate {
    public func loadHelpScene() {
        guard let view = self.view else {
            return
        }
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.presentScene(HelpScene(self.gameData), transition: SKTransition.crossFade(withDuration: 1))
        self.isViewChanged = true
    }
    
    public func loadGameScene() {
        guard let view = self.view else {
            return
        }
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.presentScene(GameScene(self.gameData), transition: SKTransition.crossFade(withDuration: 1))
        self.isViewChanged = true
    }
}
