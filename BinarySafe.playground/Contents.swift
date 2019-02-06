import PlaygroundSupport
import SpriteKit
import Foundation

let width = 500
let height = 500
let layers = 3
let pieces = 6

let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: width, height: height))
let scene = InitialScene(size: CGSize(width: width, height: height), layers: layers, pieces: pieces)

sceneView.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
