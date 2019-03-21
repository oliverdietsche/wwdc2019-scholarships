import SpriteKit
import AVFoundation

public class GameScene: SKScene {
    private var gameData: GameData
    private var innerCircle: SKShapeNode
    private var helpLabel: SKLabelNode
    private var movesLabel: SKLabelNode
    private var moves: Int
    private var touchDownRotationIndex: Int
    private var solved: Bool
    private var isLayerSelected: Bool
    private var isViewChanged: Bool
    
    private var audioPlayer: AVAudioPlayer?
    private var safe: Safe?
    private var activeLayer: CircleLayer?
    private var helpColumn: Int?
    
    private var p1 = CGPoint()
    private var p2 = CGPoint()
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    public init(_ gameData: GameData) {
        self.gameData = gameData
        self.innerCircle = SKShapeNode(circleOfRadius: CGFloat(gameData.innerRadius))
        self.helpLabel = SKLabelNode(fontNamed: "Arial")
        self.movesLabel = SKLabelNode(fontNamed: "Arial")
        self.moves = 0
        self.touchDownRotationIndex = 0
        self.solved = false
        self.isLayerSelected = false
        self.isViewChanged = false
        
        super.init(size: CGSize(width: gameData.width, height: gameData.height))
    }
    
    public override func didChangeSize(_ oldSize: CGSize) {
        if !self.isViewChanged {
            self.gameData.width = Double(self.size.width)
            self.gameData.height = Double(self.size.height)
            self.reloadScene()
        }
    }
    
    public override func didMove(to view: SKView) {
        self.setup()
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if solved {
            return
        }
        self.updateActiveLayer(touchedPos: pos)
        guard let activeLayer = self.activeLayer else {
            return
        }
        self.touchDownRotationIndex = activeLayer.getRotationIndex()
        
        self.p1 = pos
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if solved {
            return
        }
        self.p2 = pos
        
        guard let activeLayer = self.activeLayer, self.isLayerSelected else {
            return
        }
        activeLayer.rotate(angle: self.calculateAngle(point1: self.p1, point2: self.p2))
        
        self.p1 = pos
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if solved {
            return
        }
        guard let safe = self.safe else {
            return
        }
        guard let activeLayer = self.activeLayer, self.isLayerSelected else {
            return
        }
        activeLayer.snap()
        
        if self.touchDownRotationIndex != activeLayer.getRotationIndex() {
            self.moves += 1
        }
        self.movesLabel.text = "Moves: \(self.moves)"
        self.updateHelp()
        
        if safe.isSolved() {
            self.solved = true
            self.playSound(fileName: "solved");
            self.spawnParticles(position: CGPoint(x: self.gameData.center.x, y: self.gameData.center.y + CGFloat(self.gameData.innerRadius * Double(self.gameData.layers))))
        }
    }
    
    // MARK: private
    
    private func setup() {
        self.backgroundColor = .white
        
        let movesLabel_position = CGPoint(x: 10, y: self.gameData.height - Double(FontSize.medium))
        self.setupLabel(label: self.movesLabel, position: movesLabel_position, fontSize: FontSize.medium, text: "Moves: \(self.moves)", hAlignment: .left)
        
        let helpLabel_position = CGPoint(x: 10 + 50, y: self.gameData.height - Double(FontSize.medium * 2.5) - 100)
        self.setupLabel(label: self.helpLabel, position: helpLabel_position, fontSize: FontSize.large, text: "", hAlignment: .left)
        
        self.setupInnerCircle()
        self.setupButtons()
        self.setupSafe()
        self.setupCode()
    }
    
    private func setupLabel(label: SKLabelNode, position: CGPoint, fontSize: CGFloat, text: String, hAlignment: SKLabelHorizontalAlignmentMode) {
        label.position = position
        label.zPosition = 1
        label.fontSize = fontSize
        label.fontColor = .black
        label.text = text
        label.horizontalAlignmentMode = hAlignment
        label.verticalAlignmentMode = .center
        self.addChild(label)
    }
    
    private func setupInnerCircle() {
        self.innerCircle.position = self.gameData.center
        self.innerCircle.zPosition = 1
        self.innerCircle.lineWidth = self.gameData.lineWidth
        self.innerCircle.strokeColor = Color.border
        self.innerCircle.fillColor = Color.center
        self.addChild(self.innerCircle)
    }
    
    private func setupButtons() {
        let homeButton = GameControlButton(size: CGSize(width: Size.gameButton.width, height: Size.gameButton.height), type: .home, texture: SKTexture(imageNamed: "home.png"))
        homeButton.delegate = self
        homeButton.position = CGPoint(x: 10 + (Size.gameButton.width * 0.5), y: 10 + (Size.gameButton.width * 0.5))
        self.addChild(homeButton)
        
        let shuffleButton = GameControlButton(size: CGSize(width: Size.gameButton.width, height: Size.gameButton.height), type: .shuffle, texture: SKTexture(imageNamed: "shuffle.png"))
        shuffleButton.delegate = self
        shuffleButton.position = CGPoint(x: self.gameData.width - 10 - Double(Size.gameButton.width * 1.5), y: 10 + Double(Size.gameButton.height * 0.5))
        self.addChild(shuffleButton)
        
        let solveButton = GameControlButton(size: CGSize(width: Size.gameButton.width, height: Size.gameButton.height), type: .solve, texture: SKTexture(imageNamed: "solve.png"))
        solveButton.delegate = self
        solveButton.position = CGPoint(x: self.gameData.width - 10 - Double(Size.gameButton.width * 0.5), y: 10 + Double(Size.gameButton.height * 0.5))
        self.addChild(solveButton)
    }
    
    private func setupSafe() {
        var layers = [CircleLayer]()
        for iLayer in (1...self.gameData.layers).reversed() {
            var startDegree: Double = 0
            var circlePieces = [CirclePiece]()
            
            for _ in 1...self.gameData.pieces {
                let endDegree: Double = startDegree + self.gameData.degreeRange
                
                let piece = CirclePiece(gameData: self.gameData, layer: Double(iLayer), startDegree: startDegree, endDegree: endDegree)
                circlePieces.append(piece)
                
                guard let circleArc = piece.getCircleArc() else {
                    return
                }
                self.addChild(circleArc)
                
                startDegree += self.gameData.degreeRange
            }
            
            let layer = CircleLayer(gameData: self.gameData, layerNumber: iLayer, circlePieces: circlePieces)
            layers.append(layer)
        }
        
        let safe = Safe(gameData: self.gameData, layers: layers)
        safe.shuffle()
        self.playSound(fileName: "shuffle")
        
        self.safe = safe
    }
    
    private func setupCode() {
        guard let safe = self.safe else {
            return
        }
        
        let maxPossibleValue = Int(pow(2, Double(self.gameData.layers)))
        
        var code = [Int]()
        var startDegree: Double = 0
        for iPiece in 0..<self.gameData.pieces {
            let codeNumber: Int = Int.random(in: 0..<maxPossibleValue)
            let codeArray = self.intToBinaryCharArray(int: codeNumber, amountOfChars: self.gameData.layers)
            code.append(codeNumber)
            
            let shiftedAngle = startDegree.toRadians + Double(self.gameData.radianRange) * 0.5
            let radius = self.gameData.innerRadius * (Double(self.gameData.layers) + 1.5)
            let xCord = cos(shiftedAngle) * radius
            let yCord = sin(shiftedAngle) * radius
            let position = CGPoint(x: CGFloat(xCord) + self.gameData.center.x, y: CGFloat(yCord) + self.gameData.center.y)
            
            let size = sqrt(self.gameData.innerRadius * self.gameData.innerRadius * 0.5)
            let helpButton = GameHelpButton(size: CGSize(width: size, height: size), text: String(codeNumber), column: iPiece, degree: shiftedAngle.toDegrees)
            helpButton.delegate = self
            helpButton.position = position
            self.addChild(helpButton)
            
            var codeIndex = 0
            for iLayer in (0..<self.gameData.layers).reversed() {
                safe.getLayer(iLayer).getPiece(iPiece).setText(String(codeArray[codeIndex]))
                codeIndex += 1
            }
            startDegree += self.gameData.degreeRange
        }
        safe.setCode(code)
    }
    
    private func updateActiveLayer(touchedPos pos: CGPoint) {
        let radius = Double(distanceBetweenCGPoints(from: self.gameData.center, to: pos))
        let calculatedLayer = Int(radius / self.gameData.innerRadius) - self.gameData.layers
        
        guard let safe = self.safe else {
            return
        }
        let layer = self.convertCalculatedLayer(calculatedLayer)
        if layer != -1 {
            self.isLayerSelected = true
            self.activeLayer = safe.getLayer(layer)
        } else {
            self.isLayerSelected = false
        }
    }
    
    private func spawnParticles(position: CGPoint) {
        guard let particles = SKEmitterNode(fileNamed: "KeyExplosion") else {
            return
        }
        particles.position = position
        particles.targetNode = self.scene
        self.addChild(particles)
    }
    
    private func updateHelp() {
        guard let safe = self.safe else {
            return
        }
        safe.resetFillColor()
        self.helpLabel.text = ""
        guard let column = self.helpColumn else {
            return
        }
        self.helpLabel.text = safe.getCodeWithKeyFromColumn(column)
    }
    
    private func reloadScene() {
        guard let view = self.view else {
            return
        }
        view.presentScene(GameScene(self.gameData))
    }
    
    private func calculateAngle(point1 p1: CGPoint, point2 p2: CGPoint) -> CGFloat {
        let v1 = CGVector(dx: p1.x - self.gameData.center.x, dy: p1.y - self.gameData.center.y)
        let v2 = CGVector(dx: p2.x - self.gameData.center.x, dy: p2.y - self.gameData.center.y)
        return atan2(v2.dy, v2.dx) - atan2(v1.dy, v1.dx)
    }
    
    // Returns number of Layer if one's selected
    // Returns -1 if none is selected
    private func convertCalculatedLayer(_ calculatedLayer: Int) -> Int {
        if calculatedLayer > 0 || abs(calculatedLayer) >= self.gameData.layers {
            return -1
        } else {
            return abs(calculatedLayer)
        }
    }
    
    private func playSound(fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "m4a") else {
            return
        }
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.m4a.rawValue)
            guard let audioPlayer = self.audioPlayer else {
                return
            }
            audioPlayer.play()
        } catch let error {
            print(error)
        }
    }
    
    private func distanceBetweenCGPoints(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(distanceBetweenCGPointsSquared(from: from, to: to))
    }
    
    private func distanceBetweenCGPointsSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    
    private func intToBinaryCharArray(int: Int, amountOfChars: Int) -> [Character] {
        var result = String(int, radix: 2)
        while result.count < amountOfChars {
            result = "0" + result
        }
        return Array(result)
    }
}

extension GameScene: GameControlButtonDelegate, GameHelpButtonDelegate {
    public func displayHelp(column: Int) {
        if self.helpColumn == column {
            self.helpColumn = nil
        } else {
            self.helpColumn = column
        }
        self.updateHelp()
    }
    
    public func shuffleLayers() {
        guard let safe = self.safe else {
            return
        }
        safe.resetFillColor()
        
        self.moves = 0
        self.movesLabel.text = "Moves: \(self.moves)"
        
        // Make sure it's impossible for the outcome to be solved
        safe.solve(duration: 0)
        
        self.innerCircle.fillColor = Color.center
        safe.shuffle()
        self.playSound(fileName: "shuffle");
        self.solved = false
    }
    
    public func loadHomeScene() {
        guard let view = self.view else {
            return
        }
        view.presentScene(MenuScene(self.gameData), transition: SKTransition.crossFade(withDuration: 1))
        self.isViewChanged = true
    }
    
    public func solveLayers() {
        if solved {
            return
        }
        guard let safe = self.safe else {
            return
        }
        safe.resetFillColor()
        self.solved = true
        self.movesLabel.text = "Auto-Solved"
        safe.solve(duration: 1.5)
    }
}

extension GameScene {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchDown(atPoint: t.location(in: self)) }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchMoved(toPoint: t.location(in: self)) }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
}
