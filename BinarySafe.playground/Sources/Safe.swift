import Foundation
import SpriteKit

public class Safe {
    private var layers: [CircleLayer]
    
    init() {
        self.layers = [CircleLayer]()
    }
    
    public func getLayer(_ layer: Int) -> CircleLayer {
        return self.layers[layer]
    }
    
//    public func display(scene: SKScene) {
//        for i in 0..<layers.count {
//            layers[i].display(scene: scene)
//        }
//    }
    
    public func addLayer(_ layer: CircleLayer) {
        self.layers.append(layer)
    }
}
