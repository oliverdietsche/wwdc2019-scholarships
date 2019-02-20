import PlaygroundSupport
import SpriteKit
import Foundation

public class InitialScene: SKScene {
    
    var gameData: GameData
    var layers_label: UILabel?
    var pieces_label: UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    public init(_ gameData: GameData) {
        self.gameData = gameData
        super.init(size: CGSize(width: gameData.width, height: gameData.height))
    }
    
    public override func didMove(to view: SKView) {
        self.backgroundColor = .white
        
        let titleSize = CGSize(width: view.frame.width * 0.6, height: 80)
        let itemSize = CGSize(width: view.frame.width * 0.4, height: 40)
        let title_labelFrame = CGRect(origin: CGPoint(x: view.frame.width * 0.2, y: 40), size: titleSize)
        let layers_labelFrame = CGRect(origin: CGPoint(x: view.frame.width * 0.3, y: 140), size: itemSize)
        let layers_sliderFrame = CGRect(origin: CGPoint(x: view.frame.width * 0.3, y: 170), size: itemSize)
        let pieces_labelFrame = CGRect(origin: CGPoint(x: view.frame.width * 0.3, y: 240), size: itemSize)
        let pieces_sliderFrame = CGRect(origin: CGPoint(x: view.frame.width * 0.3, y: 270), size: itemSize)
        
        let title_label = UILabel(frame: title_labelFrame)
        title_label.font = UIFont(name: "Noteworthy-Bold", size: 40)
        title_label.textAlignment = .center
        title_label.text = "BinarySafe"
        
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
        
        let start_button = UIButton(frame: CGRect(x: view.frame.width * 0.3, y: 340, width: view.frame.width * 0.4, height: 40))
        
        start_button.setTitle("Start", for: .normal)
        start_button.setTitleColor(UIColor.black, for: .normal)
        
        start_button.backgroundColor = UIColor.white
        
        start_button.layer.cornerRadius = 5
        start_button.layer.borderWidth = 2
        start_button.layer.borderColor = UIColor.lightGray.cgColor
        
        start_button.addTarget(self, action: #selector(startGame(_:)), for: .touchUpInside)
        
        view.addSubview(title_label)
        view.addSubview(layers_slider)
        view.addSubview(layers_label)
        view.addSubview(pieces_slider)
        view.addSubview(pieces_label)
        view.addSubview(start_button)
    }
    
    @objc func changeLayersValue(_ sender: UISlider) {
        guard let layers_label = self.layers_label else {
            return
        }
        self.gameData.layers = Int(sender.value)
        layers_label.text = "Layers: \(self.gameData.layers)"
    }
    
    @objc func changePiecesValue(_ sender: UISlider) {
        guard let pieces_label = self.pieces_label else {
            return
        }
        self.gameData.pieces = Int(sender.value)
        pieces_label.text = "Pieces: \(self.gameData.pieces)"
    }
    
    @objc func startGame(_ sender: UIButton) {
        guard let view = self.view else {
            return
        }
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.presentScene(self.gameData.newGameScene(), transition: SKTransition.crossFade(withDuration: 1))
    }
}
