import Foundation
import SpriteKit

public class Safe {
    private let gameData: GameData
    private var layers: [CircleLayer]
    private var code: [Int]
    
    init(gameData: GameData, layers: [CircleLayer]) {
        self.gameData = gameData
        self.layers = layers
        self.code = [Int]()
    }
    
    public func resetFillColor() {
        for i in 0..<self.layers.count {
            self.layers[i].setFillColor(color: self.gameData.fillColor)
        }
    }
    
    public func setCode(_ code: [Int]) {
        self.code = code
    }
    
    public func solve(duration: Double) {
        for i in 0..<self.layers.count {
            self.layers[i].solve(duration: duration)
        }
    }
    
    public func getCodeWithKeyFromColumn(_ column: Int) -> String {
        var code = ""
        for iLayer in (0..<self.gameData.layers).reversed() {
            var pieceIndex = self.gameData.pieces - layers[iLayer].getRotationIndex()
            if pieceIndex == self.gameData.pieces {
                pieceIndex = 0
            }
            pieceIndex = (pieceIndex + column) % self.gameData.pieces
            
            let piece = layers[iLayer].getPiece(pieceIndex)
            code += piece.getText()
            piece.setFillColor(color: .yellow)
        }
        guard let calculatedKey = Int(code, radix: 2) else {
            return ""
        }
        return "\(code) = \(calculatedKey)"
    }
    
    public func isSolved() -> Bool {
        var solved: Bool = true
        
        for iPiece in 0..<self.gameData.pieces {
            
            var calculatedCode = ""
            for iLayer in (0..<self.gameData.layers).reversed() {
                var pieceIndex = self.gameData.pieces - layers[iLayer].getRotationIndex()
                if pieceIndex == self.gameData.pieces {
                    pieceIndex = 0
                }
                pieceIndex = (pieceIndex + iPiece) % self.gameData.pieces
                
                calculatedCode += layers[iLayer].getPiece(pieceIndex).getText()
            }
            guard let calculatedKey = Int(calculatedCode, radix: 2) else {
                return false
            }
//            print("\(calculatedKey)(\(code)) == \(key)")
            if calculatedKey != self.code[iPiece] {
                solved = false
            }
        }
        print("")
        
        return solved
    }
    
    public func shuffle() {
        var lastRotationIndex = 0
        var rotationIndex = Int.random(in: self.gameData.pieces..<(self.gameData.pieces * 2))
        for i in 0..<self.layers.count {
            while rotationIndex == lastRotationIndex {
                rotationIndex = Int.random(in: self.gameData.pieces..<(self.gameData.pieces * 2))
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
}
