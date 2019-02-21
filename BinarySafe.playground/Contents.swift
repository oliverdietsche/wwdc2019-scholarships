import PlaygroundSupport
import SpriteKit
import Foundation

let gameData = GameData(width: 400, height: 600, layers: 3, pieces: 4)

let sceneView = SKView(frame: gameData.frame)
let initialScene = InitialScene(gameData)

sceneView.presentScene(initialScene)
    
PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
