import PlaygroundSupport
import SpriteKit
import Foundation

public class MenuScene: SKScene {
    
    var gameData: GameData
    var layers_label: UILabel?
    var pieces_label: UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        self.gameData = GameData(layers: 0, pieces: 0, borderColor: .red, fillColor: .red, centerColor: .red)
        super.init(coder: aDecoder)
    }
    
    public init(_ gameData: GameData) {
        self.gameData = gameData
        super.init(size: CGSize(width: gameData.width, height: gameData.height))
    }
    
    public override func didMove(to view: SKView) {
        self.backgroundColor = .white
        
        let itemSize = CGSize(width: self.gameData.width * 0.4, height: 40)
        let layers_labelFrame = CGRect(origin: CGPoint(x: self.gameData.width * 0.3, y: 40), size: itemSize)
        let layers_sliderFrame = CGRect(origin: CGPoint(x: self.gameData.width * 0.3, y: 70), size: itemSize)
        let pieces_labelFrame = CGRect(origin: CGPoint(x: self.gameData.width * 0.3, y: 140), size: itemSize)
        let pieces_sliderFrame = CGRect(origin: CGPoint(x: self.gameData.width * 0.3, y: 170), size: itemSize)
        
        self.layers_label = UILabel(frame: layers_labelFrame)
        guard let layers_label = self.layers_label else {
            return
        }
        layers_label.textAlignment = .center
        layers_label.text = "Layers: \(self.gameData.layers)"
        
        let layers_slider = UISlider(frame: layers_sliderFrame)
        layers_slider.minimumValue = 2
        layers_slider.maximumValue = 6
        layers_slider.setValue(Float(self.gameData.layers), animated: false)
        layers_slider.addTarget(self, action: #selector(changeLayersValue(_:)), for: .valueChanged)
        
        self.pieces_label = UILabel(frame: pieces_labelFrame)
        guard let pieces_label = self.pieces_label else {
            return
        }
        pieces_label.textAlignment = .center
        pieces_label.text = "Pieces: \(self.gameData.pieces)"
        
        let pieces_slider = UISlider(frame: pieces_sliderFrame)
        pieces_slider.minimumValue = 2
        pieces_slider.maximumValue = 10
        pieces_slider.setValue(Float(self.gameData.pieces), animated: false)
        pieces_slider.addTarget(self, action: #selector(changePiecesValue(_:)), for: .valueChanged)
        
        let start_button = UIButton(frame: CGRect(x: self.gameData.width * 0.3, y: 240, width: self.gameData.width * 0.4, height: 40))
        
        start_button.setTitle("Start", for: .normal)
        start_button.setTitleColor(UIColor.black, for: .normal)
        
        start_button.backgroundColor = UIColor.white
        
        start_button.layer.cornerRadius = 5
        start_button.layer.borderWidth = 2
        start_button.layer.borderColor = UIColor.lightGray.cgColor
        
        start_button.addTarget(self, action: #selector(startGame(_:)), for: .touchUpInside)
        
        guard let view = self.view else {
            return
        }
        view.addSubview(layers_slider)
        view.addSubview(layers_label)
        view.addSubview(pieces_slider)
        view.addSubview(pieces_label)
        view.addSubview(start_button)
    }
    
    @objc func changeLayersValue(_ sender: UISlider) {
        self.gameData.layers = Int(sender.value)
        guard let layers_label = self.layers_label else {
            return
        }
        layers_label.text = "Layers: \(self.gameData.layers)"
    }
    
    @objc func changePiecesValue(_ sender: UISlider) {
        self.gameData.pieces = Int(sender.value)
        guard let pieces_label = self.pieces_label else {
            return
        }
        pieces_label.text = "Pieces: \(self.gameData.pieces)"
    }
    
    @objc func startGame(_ sender: UIButton) {
        let newScene = GameScene(gameData)
        guard let view = self.view else {
            return
        }
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.presentScene(newScene, transition: SKTransition.fade(with: UIColor.black, duration: 0.8))
    }
}
