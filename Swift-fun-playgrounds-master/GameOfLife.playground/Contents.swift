// Author: Matteo Battaglio - @m4dbat

import SpriteKit
import XCPlayground

let title = "Conway's Game of Life"

// Rules: http://en.wikipedia.org/wiki/Conway's_Game_of_Life#Rules

enum CellState: Int {
    case Dead = 0
    case Alive = 1
}

struct Cell {
    
    let state: CellState
    let position: (x: Int, y: Int)
    
}

func bigBang(gridWidth: Int, gridHeight: Int) -> [[Cell]] {
    return (0..<gridHeight).map { y in
        (0..<gridWidth).map { x in
            let cellState: CellState = arc4random_uniform(10) < 3 ? .Alive : .Dead
            return Cell(state: cellState, position: (x, y))
        }
    }
}

/// Initial Universe
var universe: [[Cell]] = bigBang(gridWidth: 10, gridHeight: 10)

func neighbours(index: (x: Int, y: Int)) -> [Cell] {
    var neighbours = [Cell]()
    for y in index.y-1...index.y+1 {
        for x in index.x-1...index.x+1 {
            if (x != index.x || y != index.y)
                && x >= 0
                && y >= 0
                && y < universe.count
                && x < universe[y].count {
                    neighbours.append(universe[y][x])
            }
        }
    }
    return neighbours
}

func tick(cell: Cell) -> Cell {
    let aliveNeighboursCount = neighbours(index: cell.position).reduce(0) {
        $0 + $1.state.rawValue
    }

    func newState(current currentState: CellState) -> CellState {
        if currentState == .Alive {
            switch aliveNeighboursCount {
            case 0...1: return .Dead
            case 2...3: return .Alive
            default:    return .Dead
            }
        } else {
            return aliveNeighboursCount == 3 ? .Alive : .Dead
        }
    }
    
    return Cell(state: newState(current: cell.state), position: cell.position)
}

func nextGeneration(currentGeneration: [[Cell]]) -> [[Cell]] {
    return currentGeneration.map { row in
        row.map(tick)
    }
}



// SpriteKit code

let cellSideLength = 30

func spriteColorForState(state: CellState) -> SKColor {
    return state == .Alive ? SKColor.blackColor : SKColor.lightGrayColor()
}

let universeFrame = CGRect(x: 0, y: 0, width: cellSideLength * universe.count, height: cellSideLength * universe.first!.count)
let universeView = SKView(frame: universeFrame)

let scene = SKScene(size: universeFrame.size)
scene.scaleMode = SKSceneScaleMode.aspectFit
scene.backgroundColor = SKColor.redColor
universeView.presentScene(scene)

XCPSetExecutionShouldContinueIndefinitely()
XCPShowView(identifier: "Universe", view: universeView)

var spriteToCellDict: [SKSpriteNode : (x: Int, y: Int)] = Dictionary()
for row in universe {
    for cell in row {
        let cellSprite = SKSpriteNode(color: spriteColorForState(state: cell.state), size: CGSize(width: cellSideLength, height: cellSideLength))
        cellSprite.position = CGPoint(x: cell.position.x * cellSideLength + cellSideLength/2, y: cell.position.y * cellSideLength + cellSideLength/2)
        scene.addChild(cellSprite)
        spriteToCellDict[cellSprite] = cell.position
    }
}

let wait = SKAction.wait(forDuration: 0.1)
let tick = SKAction.run {
    universe = nextGeneration(currentGeneration: universe)
    for child in scene.children {
        let node = child as! SKSpriteNode
        let position = spriteToCellDict[node]!
        node.color = spriteColorForState(state: universe[position.y][position.x].state)
    }
}
scene.run(SKAction.repeatForever(SKAction.sequence([wait, tick])))
