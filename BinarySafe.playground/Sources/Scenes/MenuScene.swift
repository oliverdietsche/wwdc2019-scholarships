import PlaygroundSupport
import SpriteKit
import Foundation

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
        
        let titleSize = CGSize(width: view.frame.width * 0.6, height: 80)
        let itemSize = CGSize(width: view.frame.width * 0.4, height: 40)
        
        let titleLabel_frame = CGRect(origin: CGPoint(x: view.frame.width * 0.2, y: 40), size: titleSize)
        let titleLabel = UILabel(frame: titleLabel_frame)
        titleLabel.font = UIFont(name: "Noteworthy-Bold", size: 40)
        titleLabel.textAlignment = .center
        titleLabel.text = "BinarySafe"
        
        let layersLabel_frame = CGRect(origin: CGPoint(x: view.frame.width * 0.3, y: 140), size: itemSize)
        let layersLabel = UILabel(frame: layersLabel_frame)
        layersLabel.textAlignment = .center
        layersLabel.text = "Layers: \(self.gameData.layers)"
        view.addSubview(layersLabel)
        self.layersLabel = layersLabel
        
        let layersSlider_frame = CGRect(origin: CGPoint(x: view.frame.width * 0.3, y: 170), size: itemSize)
        let layersSlider = self.newSlider(frame: layersSlider_frame, minValue: 2, maxValue: 6, value: Float(self.gameData.layers))
        layersSlider.addTarget(self, action: #selector(changeLayersValue(_:)), for: .valueChanged)
        view.addSubview(layersSlider)
        
        let piecesLabel_frame = CGRect(origin: CGPoint(x: view.frame.width * 0.3, y: 240), size: itemSize)
        let piecesLabel = UILabel(frame: piecesLabel_frame)
        piecesLabel.textAlignment = .center
        piecesLabel.text = "Pieces: \(self.gameData.pieces)"
        view.addSubview(piecesLabel)
        self.piecesLabel = piecesLabel
        
        let piecesSlider_frame = CGRect(origin: CGPoint(x: view.frame.width * 0.3, y: 270), size: itemSize)
        let piecesSlider = self.newSlider(frame: piecesSlider_frame, minValue: 2, maxValue: 10, value: Float(self.gameData.pieces))
        piecesSlider.addTarget(self, action: #selector(changePiecesValue(_:)), for: .valueChanged)
        view.addSubview(piecesSlider)
        
        let playButton = GameControlButton(size: CGSize(width: 120, height: 40), type: .play, texture: SKTexture(imageNamed: "play.png"))
        playButton.delegate = self
        playButton.position = CGPoint(x: Double(self.gameData.center.x), y: self.gameData.height - 360)
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
}

extension MenuScene: GameControlButtonDelegate {
    public func loadGameScene() {
        guard let view = self.view else {
            return
        }
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.presentScene(GameScene(self.gameData), transition: SKTransition.crossFade(withDuration: 1))
        self.isViewChanged = true
    }
    
    private func reloadScene() {
        guard let view = self.view else {
            return
        }
        view.presentScene(MenuScene(self.gameData))
    }
}
