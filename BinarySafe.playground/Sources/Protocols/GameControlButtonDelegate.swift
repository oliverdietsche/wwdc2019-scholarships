import Foundation

@objc protocol GameControlButtonDelegate {
    @objc optional func loadGameScene()
    @objc optional func shuffleLayers()
    @objc optional func loadHomeScene()
    @objc optional func solveLayers()
    @objc optional func loadHelpScene()
    @objc optional func showInfo()
    @objc optional func hideInfo()
}
