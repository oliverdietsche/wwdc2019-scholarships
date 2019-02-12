import PlaygroundSupport
import SpriteKit
import Foundation

let gameData = GameData(width: 400, height: 600, layers: 3, pieces: 4, borderColor: .black, fillColor: .lightGray, centerColor: .gray)

let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: gameData.width, height: gameData.height))

let initialScene = InitialScene(gameData)

sceneView.presentScene(initialScene)

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
