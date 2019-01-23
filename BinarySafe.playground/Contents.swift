import PlaygroundSupport
import SpriteKit
import Foundation

let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
let scene = InitialScene(size: CGSize(width: 600, height: 600), layers: 3, pieces: 4)

sceneView.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
