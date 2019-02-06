import Foundation
import SpriteKit

public class Safe {
    private var layers: [CircleLayer]
    private var codeLabels: [SKLabelNode]
    private var numOfPieces: Int
    private var numOfLayers: Int
    private var innerRadius: Double
    private var degreeRange: Double
    private var center: CGPoint
    
    init(layers: [CircleLayer], numOfPieces: Int, numOfLayers: Int, innerRadius: Double, degreeRange: Double, center: CGPoint) {
        self.layers = layers
        self.numOfPieces = numOfPieces
        self.numOfLayers = numOfLayers
        self.innerRadius = innerRadius
        self.degreeRange = degreeRange
        self.center = center
        
        self.codeLabels = [SKLabelNode]()
        
        let maxPossibleValue = Int(pow(2, Double(numOfLayers)))
        
        var startDegree: Double = 0
        for iPiece in 0..<numOfPieces {
            let codeNumber: Int = Int.random(in: 0..<maxPossibleValue)
            let codeArray = self.intToBinaryCharArray(int: codeNumber, amountOfChars: numOfLayers)
            
            let lb_angle = startDegree.toRadians
            
            let label = self.createLabel(angle: lb_angle)
            label.text = String(codeNumber)
            self.codeLabels.append(label)
            
            var codeIndex = 0
            for iLayer in (0..<numOfLayers).reversed() {
                layers[iLayer].getPiece(iPiece).setText(String(codeArray[codeIndex])) // codeArray[codeIndex]
                codeIndex += 1
            }
            startDegree += degreeRange
        }
    }
    
    public func getDegPos() {
        var won: Bool = true
//        for i in 0..<self.layers.count {
//            let pos = self.layers[i].getDegPos()
//            if !(pos == 0.0) && !(pos == 6.2831854820251465) {
//                won = false
//            }
//        }
        
        for iPiece in 0..<self.numOfPieces {
            
            var code = ""
            for iLayer in (0..<self.numOfLayers).reversed() {
                var pieceIndex = self.numOfPieces - Int(layers[iLayer].getRotatedIndex())
                if pieceIndex == self.numOfPieces {
                    pieceIndex = 0
                }
                pieceIndex = (pieceIndex + iPiece) % self.numOfPieces
                
                code += layers[iLayer].getPiece(pieceIndex).getText()
            }
            guard let key_string = self.codeLabels[iPiece].text else {
                return
            }
            guard let key = Int(key_string) else {
                return
            }
            guard let calculatedKey = Int(code, radix: 2) else {
                return
            }
//            print("\(calculatedKey)(\(code)) == \(key)")
            if calculatedKey != key {
                won = false
            }
        }
        
        print("\(won)\n")
    }
    
    public func shuffle() {
        for i in 0..<self.layers.count {
            self.layers[i].shuffle()
        }
    }
    
    public func getLayer(_ layer: Int) -> CircleLayer {
        return self.layers[layer]
    }
    
    public func getCodeLabels() -> [SKLabelNode] {
        return self.codeLabels
    }
    
    private func intToBinaryCharArray(int: Int, amountOfChars: Int) -> [Character] {
        var result = String(int, radix: 2)
        while result.count < amountOfChars {
            result = "0" + result
        }
        return Array(result)
    }
    
    private func createLabel(angle: Double) -> SKLabelNode {
        let shiftedAngle = angle + self.degreeRange.toRadians * 0.5
        let radius = self.innerRadius * (Double(self.numOfLayers) + 1.5)
        
        let xCord = cos(shiftedAngle) * radius
        let yCord = sin(shiftedAngle) * radius
        let posPoint = CGPoint(x: CGFloat(xCord) + self.center.x, y: CGFloat(yCord) + self.center.y)
        
        let label = SKLabelNode(fontNamed: "Arial")
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.fontSize = CGFloat(self.innerRadius * 0.8)
        label.fontColor = UIColor.black
        label.position = posPoint
        
        return label
    }
}
