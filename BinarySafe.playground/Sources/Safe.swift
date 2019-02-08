import Foundation
import SpriteKit

public class Safe {
    private let gameData: GameData
    private var layers: [CircleLayer]
    private var codeLabels: [SKLabelNode]
    
    init(gameData: GameData, layers: [CircleLayer]) {
        self.gameData = gameData
        self.layers = layers
        
        self.codeLabels = [SKLabelNode]()
        
        let maxPossibleValue = Int(pow(2, Double(self.gameData.layers)))
        
        // In methoden auslagern
        var startDegree: Double = 0
        for iPiece in 0..<self.gameData.pieces {
            let codeNumber: Int = Int.random(in: 0..<maxPossibleValue)
            let codeArray = self.intToBinaryCharArray(int: codeNumber, amountOfChars: self.gameData.layers)
            
            let lb_angle = startDegree.toRadians
            
            let label = self.createLabel(angle: lb_angle)
            label.text = String(codeNumber)
            self.codeLabels.append(label)
            
            var codeIndex = 0
            for iLayer in (0..<self.gameData.layers).reversed() {
                layers[iLayer].getPiece(iPiece).setText(String(codeArray[codeIndex]))
                codeIndex += 1
            }
            startDegree += self.gameData.degreeRange
        }
    }
    
    public func solve(duration: Double) {
        for i in 0..<self.layers.count {
            self.layers[i].solve(duration: duration)
        }
    }
    
    public func getCodeFromColumn() -> String {
        return "110"
    }
    
    public func isSolved() -> Bool {
        var solved: Bool = true
        
        for iPiece in 0..<self.gameData.pieces {
            
            var code = ""
            for iLayer in (0..<self.gameData.layers).reversed() {
                var pieceIndex = self.gameData.pieces - layers[iLayer].getRotationIndex()
                if pieceIndex == self.gameData.pieces {
                    pieceIndex = 0
                }
                pieceIndex = (pieceIndex + iPiece) % self.gameData.pieces
                
                code += layers[iLayer].getPiece(pieceIndex).getText()
            }
            guard let key_string = self.codeLabels[iPiece].text else {
                return false
            }
            guard let key = Int(key_string) else {
                return false
            }
            guard let calculatedKey = Int(code, radix: 2) else {
                return false
            }
//            print("\(calculatedKey)(\(code)) == \(key)")
            if calculatedKey != key {
                solved = false
            }
        }
        print("")
        
        return solved
    }
    
    public func shuffle() {
        var lastRotationIndex = 0
        var rotationIndex = Int.random(in: self.gameData.pieces..<(self.gameData.pieces * 3))
        for i in 0..<self.layers.count {
            while rotationIndex == lastRotationIndex {
                rotationIndex = Int.random(in: self.gameData.pieces..<(self.gameData.pieces * 4))
            }
            lastRotationIndex = rotationIndex
            self.layers[i].shuffle(rotationIndex: rotationIndex)
        }
    }
    
    public func snap() {
        for i in 0..<self.layers.count {
            self.layers[i].snap()
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
        let shiftedAngle = angle + Double(self.gameData.radianRange) * 0.5
        let radius = self.gameData.innerRadius * (Double(self.gameData.layers) + 1.5)
        
        let xCord = cos(shiftedAngle) * radius
        let yCord = sin(shiftedAngle) * radius
        let posPoint = CGPoint(x: CGFloat(xCord) + self.gameData.center.x, y: CGFloat(yCord) + self.gameData.center.y)
        
        let label = SKLabelNode(fontNamed: "Arial")
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.fontSize = CGFloat(self.gameData.innerRadius * 0.8)
        label.fontColor = UIColor.black
        label.position = posPoint
        
        return label
    }
}
