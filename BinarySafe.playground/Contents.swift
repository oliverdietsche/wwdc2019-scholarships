import PlaygroundSupport
import SpriteKit

/*:
 # Welcome to the Binary-Safe!
 
 * The safe you have to solve consists of different layers and sections containing binary values.
 * Rotate the layers until the binary code, read from the inside to the outside, results in the decimal shown on the outside of the safe.
 * You can check the current value of each section by pressing on the decimal and increase the difficulty by clicking on the home button to adjust the amount of layers and pieces.
 * Choose help if you need further explanation.
 * Enjoy!
 */

let gameViewController = GameViewController()
PlaygroundSupport.PlaygroundPage.current.liveView = gameViewController
