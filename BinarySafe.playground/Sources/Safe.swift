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
    
    public func addLayer(_ layer: CircleLayer) {
        self.layers.append(layer)
    }
}
