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
        
        let title = SKShapeNode(rectOf: self.gameData.titleSize)
        title.fillColor = .white
        title.fillTexture = SKTexture(imageNamed: "title.png")
        title.position = CGPoint(x: Double(self.gameData.center.x), y: self.gameData.height - 10 - Double(self.gameData.titleSize.height * 0.5))
        self.addChild(title)
        
        let itemSize = CGSize(width: self.gameData.width * 0.6, height: 30)
        
        let layersLabelOrigin = CGPoint(x: self.gameData.width * 0.2, y: Double(self.gameData.titleSize.height + 10))
        let layersLabel_frame = CGRect(origin: layersLabelOrigin, size: itemSize)
        let layersLabel = UILabel(frame: layersLabel_frame)
        layersLabel.textAlignment = .center
        layersLabel.text = "Layers: \(self.gameData.layers)"
        view.addSubview(layersLabel)
        self.layersLabel = layersLabel
        
        let layersSliderOrigin = CGPoint(x: self.gameData.width * 0.2, y: Double(self.gameData.titleSize.height + 1 * (itemSize.height + 10)))
        let layersSlider_frame = CGRect(origin: layersSliderOrigin, size: itemSize)
        let layersSlider = self.newSlider(frame: layersSlider_frame, minValue: Config.layersMinValue, maxValue: Config.layersMaxValue, value: Float(self.gameData.layers))// TODO: maybe min and max value in gameData
        layersSlider.addTarget(self, action: #selector(changeLayersValue(_:)), for: .valueChanged)
        view.addSubview(layersSlider)
        
        let piecesLabelOrigin = CGPoint(x: self.gameData.width * 0.2, y: Double(self.gameData.titleSize.height + 2 * (itemSize.height + 10)))
        let piecesLabel_frame = CGRect(origin: piecesLabelOrigin, size: itemSize)
        let piecesLabel = UILabel(frame: piecesLabel_frame)
        piecesLabel.textAlignment = .center
        piecesLabel.text = "Pieces: \(self.gameData.pieces)"
        view.addSubview(piecesLabel)
        self.piecesLabel = piecesLabel
        
        let piecesSliderOrigin = CGPoint(x: self.gameData.width * 0.2, y: Double(self.gameData.titleSize.height + 3 * (itemSize.height + 10)))
        let piecesSlider_frame = CGRect(origin: piecesSliderOrigin, size: itemSize)
        let piecesSlider = self.newSlider(frame: piecesSlider_frame, minValue: Config.piecesMinValue, maxValue: Config.piecesMaxValue, value: Float(self.gameData.pieces))// TODO: maybe min and max value in gameData
        piecesSlider.addTarget(self, action: #selector(changePiecesValue(_:)), for: .valueChanged)
        view.addSubview(piecesSlider)
        
        var helpButtonPosition: CGPoint
        var playButtonPosition: CGPoint
        if self.gameData.width > self.gameData.height {
            helpButtonPosition = CGPoint(x: 10 + Double(self.gameData.menuButtonSize.width * 0.5), y: self.gameData.height - 10 - Double(self.gameData.menuButtonSize.height * 0.5))
            playButtonPosition = CGPoint(x: self.gameData.width - 10 - Double(self.gameData.menuButtonSize.width * 0.5), y: self.gameData.height - 10 - Double(self.gameData.menuButtonSize.height * 0.5))
        } else {
            helpButtonPosition = CGPoint(x: self.gameData.menuButtonSize.width * 0.5 + 10, y: 10 + self.gameData.menuButtonSize.height * 0.5)
            playButtonPosition = CGPoint(x: CGFloat(self.gameData.width) - 10 - self.gameData.menuButtonSize.width * 0.5, y: 10 + self.gameData.menuButtonSize.height * 0.5)
        }
        
        let helpButton = GameControlButton(size: self.gameData.menuButtonSize, type: .help, texture: SKTexture(imageNamed: "help.png"))
        helpButton.delegate = self
        helpButton.position = helpButtonPosition
        self.addChild(helpButton)
        
        let playButton = GameControlButton(size: self.gameData.menuButtonSize, type: .play, texture: SKTexture(imageNamed: "play.png"))
        playButton.delegate = self
        playButton.position = playButtonPosition
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
        view.presentScene(GameScene(self.gameData), transition: SKTransition.crossFade(withDuration: 0))
        self.isViewChanged = true
    }
}
