import UIKit


public typealias Square = (c: Int, r: Int)
public typealias ChessSquare = (c: String, r: Int)

public typealias Piece = String
public typealias Guess = String


public extension String {
    
    public func array() -> [String] {
        
        return self.characters.map { "\($0)" }
        
    }
    
}

public extension Int {
    
    public func within(r: Range<Int>) -> Bool {
        
        return self >= r.lowerBound && self < r.upperBound
        
    }
    
}

public extension Array {
    
    public func randomize() -> [Element] {
        
        return self.sorted { _,_ in arc4random() % 2 == 0 }
        
    }
    
}


public class GoView: UIView {
    
    public var p: CGFloat = 20
    public var lineColor = UIColor.black
    
    public override func draw(_ rect: CGRect) {
        
        let c = UIGraphicsGetCurrentContext()
        
        c!.setLineCap(.round)
        c!.setLineJoin(.round)
        
        lineColor.set()
        
        let w8 = (rect.width - p * 2) / 8
        let h8 = (rect.height - p * 2) / 8
        
        for row in 0...8 {
            
            for col in 0...8 {
                
                c?.move(to: CGPoint(x: w8 * col + p,y: p))
                c?.addLine(to: CGPoint(x: w8 * col + p,y: rect.height - p))
                
                c?.move(to: CGPoint(x: p,y: h8 * row + p))
                c?.addLine(to: CGPoint(x: rect.width - p,y: h8 * row + p))
                
            }
            
        }
        
        c!.strokePath()
        
    }
    
}

class HintLabel: UILabel {
    
    var highlight: Bool = false { didSet { setNeedsDisplay() } }
    var highlightColor: UIColor = UIColor.red
    
    
    override func drawText(in rect: CGRect) {
        
        guard highlight else { return super.drawText(in: rect) }
        
        let ctx = UIGraphicsGetCurrentContext()
        
        highlightColor.set()
        
        ctx!.setLineJoin(.round)
        ctx!.setLineWidth(1)
        
        ctx!.stroke(rect.insetBy(dx: 3, dy: 3))
        
        super.drawText(in: rect)
        
    }
    
}


public class MatrixView: UIView {
    
    public var p: CGFloat = 10
    
    var lineColor = UIColor.black
    
    public override func draw(_ rect: CGRect) {
        
        let c = UIGraphicsGetCurrentContext()
        
        c!.setLineCap(.round)
        c!.setLineJoin(.round)
        c!.setLineWidth(2)
        
        lineColor.set()
        
        c?.move(to: CGPoint(x: p * 2,y: p))
        c?.addLine(to: CGPoint(x: p,y: p))
        c?.addLine(to: CGPoint(x: p,y: rect.height - p))
        c?.addLine(to: CGPoint(x: p * 2,y: rect.height - p))
        
        c?.move(to: CGPoint(x: rect.width - p * 2,y: p))
        c?.addLine(to: CGPoint(x: rect.width - p,y: p))
        c?.addLine(to:  CGPoint(x: rect.width - p,y: rect.height - p))
        c?.addLine(to: CGPoint(x: rect.width - p * 2,y: rect.height - p))
        
        c!.strokePath()
        
    }
    
}

public class SudokuView: UIView {
    
    var lineColor = UIColor.black
    
    public override func draw(_ rect: CGRect) {
        
        let c = UIGraphicsGetCurrentContext()
        
        c!.setLineCap(.round)
        c!.setLineJoin(.round)
        
        lineColor.set()
        
        let w9 = rect.width / 9
        let h9 = rect.height / 9
        
        for row in 1...8 {
            
            for col in 1...8 {
                
                c!.setLineWidth(col % 3 == 0 ? 3 : 1)
                
                c!.move(to: CGPoint(x: w9 * col,y: 0))
                c?.addLine(to: CGPoint(x: w9 * col,y: rect.height))
                
                c!.strokePath()
                
                c!.setLineWidth(row % 3 == 0 ? 3 : 1)
                
                c!.move(to: CGPoint(x: 0,y: h9 * row))
                c!.addLine(to: CGPoint(x: rect.width,y: h9 * row))
                
                c!.strokePath()
                
            }
            
        }
        
    }
    
}

public class TicTacToeView: UIView {
    
    public var p: CGFloat = 10
    
    public override func draw(_ rect: CGRect) {
        
        let c = UIGraphicsGetCurrentContext()
        
        c!.setLineCap(.round)
        c!.setLineJoin(.round)
        c!.setLineWidth(2)
        
        let w3 = (rect.width - p * 2) / 3
        let h3 = (rect.height - p * 2) / 3
        
        c!.move(to: CGPoint(x: w3 + p,y: p))
        c!.addLine(to: CGPoint(x: w3 + p,y: rect.height - p))
        
        c!.move(to: CGPoint(x: w3 * 2 + p,y: p))
        c!.addLine(to: CGPoint(x: w3 * 2 + p,y: rect.height - p))
        
        c?.move(to: CGPoint(x: p,y: h3 + p))
        c?.addLine(to: CGPoint(x: rect.width - p,y: h3 + p))
        
        c?.move(to: CGPoint(x: p,y: h3 * 2 + p))
        c?.addLine(to: CGPoint(x: rect.width - p,y: h3 * 2 + p))
        
        c?.strokePath()
        
    }
    
}

public class Grid {
    
    public var content: [[AnyObject]]
    
    public var rowRange: Range<Int> { return 0..<content.count }
    public var colRange: Range<Int> { return content.count > 0 ? 0..<content[0].count : 0..<0 }
    
    public var boardColors = BoardColors()
    public var playerPieces: [Piece] = []
    
    public init(_ content: [[AnyObject]]) {
        
        self.content = content
        
    }
    
    public func checker(rect: CGRect, highlights: [Square], selected: Square?) -> UIView {
        
        let view = UIView(frame: rect)
        
        let w = rect.width / content.count
        let h = rect.height / content.count
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {
                
                let label = HintLabel(frame: CGRect(x: c * w, y: r * h, width: w, height: h))
                var piece = "\(item)"
                
                label.backgroundColor = (c + r) % 2 == 0 ? boardColors.background : boardColors.foreground
                label.textColor = player(piece: piece) == 0 ? boardColors.player1 : boardColors.player2
                label.highlightColor = boardColors.highlight
                
                if player(piece: piece) == 1 {
                    
                    if let index = playerPieces[1].array().index(of: piece) { piece = playerPieces[0].array()[index] }
                    
                }
                
                if selected?.0 == r && selected?.1 == c { label.textColor = boardColors.selected }
                for highlight in highlights { label.highlight = label.highlight ? true : highlight.0 == r && highlight.1 == c }
                
                label.text = piece
                label.textAlignment = .center
                label.font = UIFont.init(name: "HelveticaNeue-Thin", size: (w + h) / 2 - 10)
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
    public func go(rect: CGRect) -> UIView {
        
        let view = GoView(frame: rect)
        
        view.p = 30
        view.backgroundColor = boardColors.background
        view.lineColor = boardColors.foreground
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let p = 30
        let w = (rect.width - p * 2) / 8
        let h = (rect.height - p * 2) / 8
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {
                
                let label = UILabel(frame: CGRect(x: c * w + p - w / 2, y: r * h + p - h / 2, width: w, height: h))
                var piece = "\(item)"
                
                label.textColor = player(piece: piece) == 0 ? boardColors.player1 : boardColors.player2
                
                if player(piece: piece) == 1 {
                    
                    if let index = playerPieces[1].array().index(of: piece) { piece = playerPieces[0].array()[index] }
                    
                }
                
                label.text = piece
                label.textAlignment = .center
                label.font = UIFont.init(name: "HelveticaNeue-Thin", size: (w + h) / 2)!
                
                view.addSubview(label)
                
                
            }
            
        }
        
        return view
        
    }
    
    public func matrix(rect: CGRect) -> UIView {
        
        let view = MatrixView(frame: rect)
        
        view.p = 15
        view.backgroundColor = boardColors.background
        view.lineColor = boardColors.foreground
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let p = 20
        let w = (rect.width - p * 2) / content.count
        let h = (rect.height - p * 2) / content.count
        
        for (c,col) in content.enumerated() {
            
            for (r,item) in col.enumerated() {
                
                let label = UILabel(frame: CGRect(x: c * w + p, y: r * h + p, width: w, height: h))
                
                label.text = "\(item)"
                label.textAlignment = .center
                label.font = UIFont.init(name: "HelveticaNeue-Thin", size: (w + h) / 2 - 10)!
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
    public func mine(rect: CGRect) -> UIView {
        
        let view = UIView(frame: rect)
        
        view.backgroundColor = boardColors.background
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let w = (rect.width - content.count + 1) / content.count
        let h = (rect.height - content.count + 1) / content.count
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {
                
                let label = UILabel(frame: CGRect(x: c * w + c, y: r * h + r, width: w, height: h))
                let piece = "\(item)"
                
                label.text = piece
                label.textAlignment = .center
                label.font = UIFont.init(name: "HelveticaNeue", size: (w + h) / 2 - 5)!
                
                label.textColor = player(piece: piece) == 0 ? boardColors.player1 : boardColors.player2
                label.backgroundColor = player(piece: piece) == 1 ? boardColors.selected : boardColors.background
                
                if piece == "•" {
                    
                    label.textColor = boardColors.foreground
                    label.backgroundColor = boardColors.foreground
                    
                }
                
                if let num = Int("\(item)"), num > 0 { label.textColor = boardColors.highlight }
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
    public func sudoku(rect: CGRect, highlights: [Square]) -> UIView {
        
        let view = SudokuView(frame: rect)
        
        view.backgroundColor = boardColors.background
        view.lineColor = boardColors.foreground
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let w = rect.width / content.count
        let h = rect.height / content.count
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {
                
                let label = UILabel(frame: CGRect(x: c * w, y: r * h, width: w, height: h))
                
                label.text = "\(item)"
                label.textAlignment = .center
                label.font = UIFont.init(name: "HelveticaNeue", size: (w + h) / 2 - 10)!
                label.textColor = boardColors.foreground
                
                for highlight in highlights {
                    
                    guard highlight.0 == r && highlight.1 == c else { continue }
                    label.textColor = boardColors.highlight
                    label.backgroundColor = boardColors.foreground
                    
                }
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
    public func ttt(rect: CGRect) -> UIView {
        
        let view = TicTacToeView(frame: rect)
        
        view.p = 20
        view.backgroundColor = boardColors.background
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let p = 20
        let w = (rect.width - p * 2) / content.count
        let h = (rect.height - p * 2) / content.count
        
        for (r,row) in content.enumerated() {
            
            for (c,item) in row.enumerated() {
                
                let label = UILabel(frame: CGRect(x: c * w + p, y: r * h + p, width: w, height: h))
                let piece = "\(item)"
                
                label.text = piece
                label.textAlignment = .center
                label.font = UIFont.init(name: "HelveticaNeue-Thin", size: (w + h) / 2 - 10)
                label.textColor = player(piece: piece) == 0 ? boardColors.player1 : boardColors.player2
                
                view.addSubview(label)
                
            }
            
        }
        
        return view
        
    }
    
    public func onBoard(s1: Square, _ s2: Square) -> Bool {
        
        return s1.0.within(r: rowRange) && s1.1.within(r: colRange) && s2.0.within(r: rowRange) && s2.1.within(r: colRange)
        
    }
    
    public func onBoard(s1: Square) -> Bool {
        
        return s1.0.within(r: rowRange) && s1.1.within(r: colRange)
        
    }
    
    public subscript ( c: Int, r: Int) -> AnyObject {
        
        get { return content[c][r] }
        set { content[c][r] = newValue }
        
    }
    
    public subscript ( c: Int) -> [AnyObject] {
        
        get { return content[c] }
        set { content[c] = newValue }
        
    }
    
    func player(piece: Piece) -> Int {
        
        for (p,player) in playerPieces.enumerated() {
            
            if player.contains(piece) { return p }
            
        }
        
        return -1
        
    }
    
}

public func * (lhs: CGFloat, rhs: Int) -> CGFloat {
    
    return lhs * CGFloat(rhs)
    
}

public func * (lhs: Int, rhs: CGFloat) -> CGFloat {
    
    return CGFloat(lhs) * rhs
    
}

public func / (lhs: CGFloat, rhs: Int) -> CGFloat {
    
    return lhs / CGFloat(rhs)
    
}

public func / (lhs: Int, rhs: CGFloat) -> CGFloat {
    
    return CGFloat(lhs) / rhs
    
}

public func + (lhs: CGFloat, rhs: Int) -> CGFloat {
    
    return lhs + CGFloat(rhs)
    
}

public func + (lhs: Int, rhs: CGFloat) -> CGFloat {
    
    return CGFloat(lhs) + rhs
    
}

public func - (lhs: CGFloat, rhs: Int) -> CGFloat {
    
    return lhs - CGFloat(rhs)
    
}

public func - (lhs: Int, rhs: CGFloat) -> CGFloat {
    
    return CGFloat(lhs) - rhs
    
}

// MATRIX

infix operator ✕ { associativity left precedence 100 }

public func ✕ <T: AnyObject>(lhs: Int, rhs: (Int) -> T) -> [T] {
    
    var a: [T] = []
    
    for i in 0..<lhs { let r = rhs(i); a.append(r) }
    
    return a
    
}

public func ✕ <T: AnyObject>(lhs: Int, rhs: T) -> [T] {
    
    return [T](repeating: rhs, count: lhs)
    
}

public func ✕ <T: AnyObject>(lhs: Int, rhs: [T]) -> [[T]] {
    
    return [[T]](repeating: rhs, count: lhs)
    
}

public func ✕ <T: AnyObject>(lhs: Int, rhs: T.Type) -> [T?] {
    
    return [T?](repeating: nil, count: lhs)
    
}

infix operator %% { associativity left precedence 150 }

public func %% <T: AnyObject>(lhs: T, rhs: T) -> (Int) -> (AnyObject) {
    
    return { $0 % 2 == 0 ? lhs : rhs }
    
}

public struct BoardColors {
    
    public var background = UIColor.white
    public var foreground = UIColor.black
    
    public var player1 = UIColor.red
    public var player2 = UIColor.blue
    
    public var highlight = UIColor.green
    public var selected = UIColor.green
    
    public init() { }
    
}




public enum MoveError: Error {
    
    /// Good try. Need a hint?
    case IncorrectGuess
    /// Seriously??? There is no reason to go off the board.
    case OutOfBounds
    /// Piece cannot move to that square
    case InvalidMove
    /// Cannot take out your own piece
    case FriendlyFire
    /// Another piece is in the way
    case BlockedMove
    /// Piece is not of the current player
    case NotYourTurn
    /// Ummm... I think you may be lost
    case NoPlayer
    /// What type of game are you playing???
    case IncorrectPiece
    /// Validation is unfinished... not letting you cheat.
    case ValidationFailed
    
}

public enum GameStatus: Error {
    
    /// Ouch. Why don't you try again?
    case GameOver
    /// You win! Don't let it go to your head.
    case Winner
    /// This is awkward.
    case Stalemate
    
}

public enum FunctionalityError: Error {
    
    /// Can't do this... maybe a future feature if you bug me enough.
    case Unavailable
    
}

public struct Checkers {
    
    public enum PieceType: String {
        
        case None = ""
        case Checker1 = "●"
        case Checker2 = "○"
        
        case King1 = "◉"
        case King2 = "◎"
        
    }
    
    public static var board: Grid {
        
        let grid = Grid(8 ✕ (8 ✕ ("" as AnyObject)))
        
        grid[0] = 8 ✕ (("" as AnyObject) %% ("●" as AnyObject))
        grid[1] = 8 ✕ (("●" as AnyObject) %% ("" as AnyObject))
        grid[2] = 8 ✕ (("" as AnyObject) %% ("●" as AnyObject))
        grid[5] = 8 ✕ (("○" as AnyObject) %% ("" as AnyObject))
        grid[6] = 8 ✕ (("" as AnyObject) %% ("○" as AnyObject))
        grid[7] = 8 ✕ (("○" as AnyObject) %% ("" as AnyObject))
        
        return grid
        
    }
    
    public static let playerPieces = ["●◉","○◎"]
    
    public static func validateJump(s1: Square, s2: Square, p1: Piece, p2: Piece, grid: Grid, hint: Bool = false) -> Bool {
        
        let m1 = s2.0 - s1.0
        let m2 = s2.1 - s1.1
        
        let e1 = s1.0 + m1 / 2
        let e2 = s1.1 + m2 / 2
        
        
        switch PieceType(rawValue: p1) ?? .None {
            
        case .Checker1:
            
            guard m1 == 2 && abs(m2) == 2 else { return false }
            
        case .Checker2:
            
            guard m1 == -2 && abs(m2) == 2 else { return false }
            
        case .King1, .King2:
            
            guard abs(m1) == 2 && abs(m2) == 2 else { return false }
            
        case .None: return false
            
        }
        
        guard let piece1 = grid[s1.0,s1.1] as? String else { return false }
        guard let piece2 = grid[e1,e2] as? String else { return false }
        guard piece2 != "" && piece1 != piece2 else { return false }
        
        guard !hint else { return true }
        
        grid[e1,e2] = "" as AnyObject // remove other player piece
        
        return true
        
    }
    
    public static func validateMove(s1: Square, s2: Square, p1: Piece, p2: Piece, grid: Grid, hint: Bool = false) throws -> Piece? {
        
        let m1 = s2.0 - s1.0
        let m2 = s2.1 - s1.1
        
        guard p2 == "" else { throw MoveError.InvalidMove }
        
        switch PieceType(rawValue: p1) ?? .None {
            
        case .Checker1:
            
            guard (m1 == 1 && abs(m2) == 1) || validateJump(s1: s1, s2: s2, p1: p1, p2: p2, grid: grid, hint: hint) else { throw MoveError.InvalidMove }
            
        case .Checker2:
            
            guard (m1 == -1 && abs(m2) == 1) || validateJump(s1: s1, s2: s2, p1: p1, p2: p2, grid: grid, hint: hint) else { throw MoveError.InvalidMove }
            
        case .King1, .King2:
            
            guard (abs(m1) == 1 && abs(m2) == 1) || validateJump(s1: s1, s2: s2, p1: p1, p2: p2, grid: grid, hint: hint) else { throw MoveError.InvalidMove }
            
        case .None: throw MoveError.IncorrectPiece
            
        }
        
        guard !hint else { return nil }
        
        let piece = grid[s2.0,s2.1]
        
        grid[s2.0,s2.1] = p1 as AnyObject // place my piece in target square
        grid[s1.0,s1.1] = "" as AnyObject // remove my piece from original square
        
        return piece as? Piece
        
    }
    
}

public struct Chess {
    
    public enum PieceType: String {
        
        case None = ""
        
        case Rook1 = "♜"
        case Knight1 = "♞"
        case Bishop1 = "♝"
        case Queen1 = "♛"
        case King1 = "♚"
        case Pawn1 = "♟"
        
        case Rook2 = "♖"
        case Knight2 = "♘"
        case Bishop2 = "♗"
        case Queen2 = "♕"
        case King2 = "♔"
        case Pawn2 = "♙"
        
    }
    
    public static var board: Grid {
        
        let grid = Grid(8 ✕ (8 ✕ ("" as AnyObject)))
        
        grid[0] = ["♜" as AnyObject,"♞" as AnyObject,"♝" as AnyObject,"♛" as AnyObject,"♚" as AnyObject,"♝" as AnyObject,"♞" as AnyObject,"♜" as AnyObject]
        grid[1] = 8 ✕ ("♟" as AnyObject)
        grid[6] = 8 ✕ ("♙" as AnyObject)
        grid[7] = ["♖" as AnyObject,"♘" as AnyObject,"♗" as AnyObject,"♕" as AnyObject,"♔" as AnyObject,"♗" as AnyObject,"♘" as AnyObject,"♖" as AnyObject]
        
        return grid
        
    }
    
    public static let playerPieces = ["♜♞♝♛♚♝♞♜♟","♖♘♗♕♔♗♘♖♙"]
    
    public static func validateEmptyPath(s1: Square, s2: Square, grid: Grid) throws {
        
        let mRow = s2.0 - s1.0
        let mCol = s2.1 - s1.1
        
        let d1 = mRow == 0 ? 0 : mRow > 0 ? 1 : -1
        let d2 = mCol == 0 ? 0 : mCol > 0 ? 1 : -1
        
        var p1 = s1.0 + d1, p2 = s1.1 + d2
        
        while p1 != s2.0 || p2 != s2.1 {
            
            guard let piece = grid[p1,p2] as? Piece, piece == "" else { throw MoveError.BlockedMove }
            
            p1 += d1
            p2 += d2
            
        }
        
    }
    
    public static func validateMove(s1: Square, s2: Square, p1: Piece, p2: Piece, grid: Grid, hint: Bool = false) throws -> Piece? {
        
        let mRow = s2.0 - s1.0
        let mCol = s2.1 - s1.1
        
        //        let dR = mRow == 0 ? 0 : mRow > 0 ? 1 : -1
        //        let dC = mCol == 0 ? 0 : mCol > 0 ? 1 : -1
        
        switch PieceType(rawValue: p1) ?? .None {
            
        case .Bishop1, .Bishop2:
            
            guard abs(mRow) == abs(mCol) else { throw MoveError.InvalidMove }
            try validateEmptyPath(s1: s1, s2: s2, grid: grid)
            
        case .King1, .King2:
            
            guard abs(mRow) < 2 && abs(mCol) < 2 else { throw MoveError.InvalidMove }
            
        case .Knight1, .Knight2:
            
            guard (abs(mRow) == 2 && abs(mCol) == 1) || (abs(mRow) == 1 && abs(mCol) == 2) else { throw MoveError.InvalidMove }
            
        case .Pawn1:
            
            guard (abs(mCol) == 0 && p2 == "") || (abs(mCol) == 1 && mRow == 1 && p2 != "") else { throw MoveError.InvalidMove }
            guard (mRow < 2 && mRow > 0) || (s1.0 == 1 && mRow == 2) else { throw MoveError.InvalidMove }
            try validateEmptyPath(s1: s1, s2: s2, grid: grid)
            
        case .Pawn2:
            
            guard (abs(mCol) == 0 && p2 == "") || (abs(mCol) == 1 && mRow == -1 && p2 != "") else { throw MoveError.InvalidMove }
            guard (mRow > -2 && mRow < 0) || (s1.0 == 6 && mRow == -2) else { throw MoveError.InvalidMove }
            try validateEmptyPath(s1: s1, s2: s2, grid: grid)
            
        case .Queen1, .Queen2:
            
            guard mRow == 0 || mCol == 0 || abs(mRow) == abs(mCol) else { throw MoveError.InvalidMove }
            try validateEmptyPath(s1: s1, s2: s2, grid: grid)
            
        case .Rook1, .Rook2:
            
            guard mRow == 0 || mCol == 0 else { throw MoveError.InvalidMove }
            try validateEmptyPath(s1: s1, s2: s2, grid: grid)
            
        case .None: throw MoveError.IncorrectPiece
            
        }
        
        guard !hint else { return nil }
        
        let piece = grid[s2.0,s2.1]
        
        grid[s2.0,s2.1] = p1 as AnyObject // place my piece in target square
        grid[s1.0,s1.1] = "" as AnyObject // remove my piece from original square
        
        return piece as? Piece
        
    }
    
}


// Coordinates

public let A8 = ("a",8), A7 = ("a",7), A6 = ("a",6), A5 = ("a",5), A4 = ("a",4), A3 = ("a",3), A2 = ("a",2), A1 = ("a",1)
public let B8 = ("b",8), B7 = ("b",7), B6 = ("b",6), B5 = ("b",5), B4 = ("b",4), B3 = ("b",3), B2 = ("b",2), B1 = ("b",1)
public let C8 = ("c",8), C7 = ("c",7), C6 = ("c",6), C5 = ("c",5), C4 = ("c",4), C3 = ("c",3), C2 = ("c",2), C1 = ("c",1)
public let D8 = ("d",8), D7 = ("d",7), D6 = ("d",6), D5 = ("d",5), D4 = ("d",4), D3 = ("d",3), D2 = ("d",2), D1 = ("d",1)
public let E8 = ("e",8), E7 = ("e",7), E6 = ("e",6), E5 = ("e",5), E4 = ("e",4), E3 = ("e",3), E2 = ("e",2), E1 = ("e",1)
public let F8 = ("f",8), F7 = ("f",7), F6 = ("f",6), F5 = ("f",5), F4 = ("f",4), F3 = ("f",3), F2 = ("f",2), F1 = ("f",1)
public let G8 = ("g",8), G7 = ("g",7), G6 = ("g",6), G5 = ("g",5), G4 = ("g",4), G3 = ("g",3), G2 = ("g",2), G1 = ("g",1)
public let H8 = ("h",8), H7 = ("h",7), H6 = ("h",6), H5 = ("h",5), H4 = ("h",4), H3 = ("h",3), H2 = ("h",2), H1 = ("h",1)


enum GoError: Error {
    
    typealias RawValue = Int
    case OpenChain
    
}

public struct Go {
    
    public static var board: Grid { return Grid(9 ✕ (9 ✕ ("" as AnyObject))) }
    
    public static let playerPieces = ["●","○"]
    
    public static func checkCapture(s1: Square, p1: Piece, grid: Grid) {
        
        let points = [ (-1,0),(0,1),(1,0),(0,-1) ]
        
        func checkChain(s1: Square, _ chain: [Square]) throws -> [Square] {
            
            var chain = chain
            
            var squares = [s1]
            
            for p in points {
                
                let s = (s1.0 + p.0, s1.1 + p.1)
                guard !(chain.contains { $0.0 == s.0 && $0.1 == s.1 }) else { continue }
                guard grid.onBoard(s1: s) else { continue }
                guard let a1 = grid[s.0,s.1] as? Piece, a1 != p1 else { continue }
                guard a1 != "" else { throw GoError.OpenChain }
                
                chain.append(s)
                
                do { squares += try checkChain(s1: s, chain) } catch { throw error }
                
            }
            
            return squares
            
        }
        
        for p in points {
            
            let s = (s1.0 + p.0, s1.1 + p.1)
            guard grid.onBoard(s1: s) else { continue }
            guard let a1 = grid[s.0,s.1] as? Piece, a1 != "" && a1 != p1 else { continue }
            
            if let squares = try? checkChain(s1: s, [s]) {
                
                for s in squares { grid[s.0,s.1] = ("" as AnyObject)}
                
            }
            
        }
        
    }
    
    public static func validateMove(s1: Square, p1: Piece, grid: Grid, player: Int) throws {
        
        guard p1 == "" else { throw MoveError.InvalidMove }
        
        grid[s1.0,s1.1] = playerPieces[player] as AnyObject
        
        checkCapture(s1: s1, p1: playerPieces[player], grid: grid)
        
    }
    
}

public struct Minesweeper {
    
    public static var board: Grid {
        
        // randomize play area
        
        let grid = Grid(10 ✕ (10 ✕ (" " as AnyObject)))
        
        for (r,_) in grid.content.enumerated() { grid[r,4] = "•" as AnyObject }
        for (r,row) in grid.content.enumerated() { grid[r] = row.randomize().randomize().randomize() }
        
        return addMineCount(grid: grid)
        
    }
    
    public static var staticboard: Grid {
        
        let grid = Grid([
            
            "   •      ".array() as Array<AnyObject>,
            "•     •   ".array() as Array<AnyObject>,
            " •  •  •  ".array() as Array<AnyObject>,
            "         •".array() as Array<AnyObject>,
            " •        ".array() as Array<AnyObject>,
            "      •   ".array() as Array<AnyObject>,
            "          ".array() as Array<AnyObject>,
            "    •     ".array() as Array<AnyObject>,
            "        • ".array() as Array<AnyObject>,
            "•     ••  ".array() as Array<AnyObject>
            
            ])
        
        return addMineCount(grid: grid)
        
    }
    
    public static var field: Grid { return Grid(10 ✕ (10 ✕ ("•" as AnyObject))) }
    
    public static let playerPieces = ["⚑","✘"]
    
    public static func validateGuess(s1: Square, grid: Grid, solution: Grid) throws {
        
        guard let a1 = solution[s1.0,s1.1] as? Guess else { throw MoveError.IncorrectPiece }
        guard a1 != "⚑" else { throw MoveError.InvalidMove }
        
        grid[s1.0,s1.1] = a1 as AnyObject
        
        guard a1 != "•" else { grid[s1.0,s1.1] = "✘" as AnyObject; throw GameStatus.GameOver }
        guard a1 == " " else { return }
        
        try checkAdjacent(s1: s1, grid: grid, solution: solution)
        
    }
    
    public static func validateMark(s1: Square, grid: Grid, solution: Grid) throws {
        
        guard let g1 = grid[s1.0,s1.1] as? Guess else { throw MoveError.IncorrectPiece }
        
        guard g1 != "⚑" else { return grid[s1.0,s1.1] = ("•" as AnyObject) }
        
        grid[s1.0,s1.1] = "⚑" as AnyObject
        
    }
    
    public static func checkAdjacent(s1: Square, grid: Grid, solution: Grid) throws {
        
        let adjacent2 = [ (-1,-1),(-1,0),(-1,1),(0,1),(1,1),(1,0),(1,-1),(0,-1) ]
        
        for a in adjacent2 {
            
            let s = (s1.0 + a.0, s1.1 + a.1)
            guard grid.onBoard(s1: s) else { continue }
            guard let a1 = solution[s.0,s.1] as? String, let g1 = grid[s.0,s.1] as? String, g1 != a1 else { continue }
            
            grid[s.0,s.1] = a1 as AnyObject
            
            guard a1 == " " else { continue }
            
            try checkAdjacent(s1: s, grid: grid, solution: solution)
            
        }
        
    }
    
    public static func addMineCount(grid: Grid) -> Grid {
        
        for r in grid.rowRange.lowerBound..<grid.rowRange.upperBound {
            
            for c in grid.colRange.lowerBound..<grid.colRange.upperBound {
                
                guard let g1 = grid[r,c] as? String else { continue }
                guard g1 != "•" else { continue }
                
                let mines = mineCount(s1: (r,c), grid)
                
                grid[r,c] = mines == 0 ? (" " as AnyObject) : ("\(mines)" as AnyObject)
                
            }
            
        }
        
        return grid
        
    }
    
    public static func mineCount(s1: Square, _ grid: Grid) -> Int {
        
        var count = 0
        
        let adjacent2 = [ (-1,-1),(-1,0),(-1,1),(0,1),(1,1),(1,0),(1,-1),(0,-1) ]
        
        for a in adjacent2 {
            
            let s = (s1.0 + a.0, s1.1 + a.1)
            guard grid.onBoard(s1: s) else { continue }
            guard let a1 = grid[s.0,s.1] as? String else { continue }
            if a1 == "•" { count += 1 }
            
        }
        
        return count
        
    }
    
}

public struct Sudoku {
    
    public static var board: Grid {
        
        let grid = Grid([
            
            "123456789".array() as Array<AnyObject>,
            "456789123".array() as Array<AnyObject>,
            "789123456".array() as Array<AnyObject>,
            "234567891".array() as Array<AnyObject>,
            "567891234".array() as Array<AnyObject>,
            "891234567".array() as Array<AnyObject>,
            "345678912".array() as Array<AnyObject>,
            "678912345".array() as Array<AnyObject>,
            "912345678".array() as Array<AnyObject>
            
            ])
        
        return randomize(grid: grid)
        
    }
    
    public static var staticboard: Grid {
        
        let grid = Grid([
            
            "123456789".array() as Array<AnyObject>,
            "456789123".array() as Array<AnyObject>,
            "789123456".array() as Array<AnyObject>,
            "234567891".array() as Array<AnyObject>,
            "567891234".array() as Array<AnyObject>,
            "891234567".array() as Array<AnyObject>,
            "345678912".array() as Array<AnyObject>,
            "678912345".array() as Array<AnyObject>,
            "912345678".array() as Array<AnyObject>
            
            ])
        
        return Grid([ grid[6], grid[8], grid[7], grid[1], grid[0], grid[2], grid[5], grid[3], grid[4] ])
        
    }
    
    public static let playerPieces = ["123456789"]
    
    public static func validateGuess(s1: Square, g1: Guess, grid: Grid, solution: Grid) throws {
        
        guard g1 != "" else { throw MoveError.InvalidMove }
        guard let a1 = solution[s1.0,s1.1] as? Guess else { throw MoveError.IncorrectPiece }
        
        print(a1)
        print(g1)
        
        guard a1 == g1 else { throw MoveError.IncorrectGuess }
        
        grid[s1.0,s1.1] = g1 as AnyObject
        
    }
    
    static func randomize(grid: Grid) -> Grid {
        
        var grid = grid
        
        for _ in 0...2 {
            
            let g1 = [grid[0],grid[1],grid[2]].randomize()
            let g2 = [grid[3],grid[4],grid[5]].randomize()
            let g3 = [grid[6],grid[7],grid[8]].randomize()
            
            grid = Grid([ g1[0], g1[1], g1[2], g2[0], g2[1], g2[2], g3[0], g3[1], g3[2] ])
            
            grid = flipGrid(grid: grid)
            
        }
        
        return grid
        
    }
    
    static func flipGrid(grid: Grid) -> Grid {
        
        let newGrid = Grid(9 ✕ (9 ✕ ("" as AnyObject)))
        
        for r in newGrid.rowRange.lowerBound...newGrid.rowRange.upperBound {
            
            for c in newGrid.colRange.lowerBound...newGrid.colRange.upperBound {
                
                newGrid[c,r] = grid[r,c]
                
            }
            
        }
        
        return newGrid
        
    }
    
    static func puzzle(grid: Grid) -> Grid {
        
        let grid = Grid(grid.content)
        
        for r in 0...8 {
            
            var cols = [0,1,2,3,4,5,6,7,8].randomize()
            
            cols.removeSubrange(3...5)
            
            for c in cols {
                
                grid[r,c] = "" as AnyObject
                
            }
            
        }
        
        return grid
        
    }
    
    static func staticpuzzle(grid: Grid) -> Grid {
        
        let grid = Grid(grid.content)
        
        let hide = [
            
            [0,2,3,4,6,7],
            [0,1,3,6,7,8],
            [1,2,3,5,6,7],
            [0,1,2,4,5,8],
            [0,1,4,6,7,8],
            [2,3,4,5,7,8],
            [0,1,2,5,6,7],
            [0,3,4,5,6,8],
            [1,3,4,6,7,8]
            
        ]
        
        for (r,row) in hide.enumerated() {
            
            for c in row {
                
                grid[r,c] = ("" as AnyObject)
                
            }
            
        }
        
        return grid
        
    }
    
}

public struct TicTacToe {
    
    public static var board: Grid { return Grid(3 ✕ (3 ✕ ("" as AnyObject))) }
    
    public static let playerPieces = ["✕","○"]
    
    public static func validateMove(s1: Square, p1: Piece, grid: Grid, player: Int) throws {
        
        guard p1 == "" else { throw MoveError.InvalidMove }
        
        grid[s1.0,s1.1] = playerPieces[player] as AnyObject // place my piece in target square
        
    }
    
}

public struct Gameboard {
    
    public enum BoardType: String {
        
        case Checkers, Chess, Go, Mancala, Minesweeper, Sudoku, TicTacToe
        
    }
    
    public enum DifficultyLevel: String {
        
        case Easy, Medium, Hard, Expert, Nightmare
        
    }
    
    public var boardColors = BoardColors() { didSet { grid.boardColors = boardColors } }
    
    var _type: BoardType
    
    var playerCount: Int = 2
    var playerTurn: Int = 0 { didSet { playerChange?(playerTurn + 1) } }
    var playerPieces: [Piece] = [] { didSet { grid.playerPieces = playerPieces } }
    
    var grid: Grid = Grid(1 ✕ (1 ✕ ("" as AnyObject)))
    var solution: Grid = Grid(1 ✕ (1 ✕ ("" as AnyObject)))
    
    var gridSize: Int { return grid.content.count }
    
    var _size: Int?
    var _difficulty: DifficultyLevel = .Easy
    
    public var playerChange: ((Int) -> ())?
    
    public init(_ type: BoardType) {
        
        _type = type
        reset()
        
    }
    
    public init(_ type: BoardType, testing: Bool) {
        
        _type = type
        reset(testing: testing)
        
    }
    
    public init(_ type: BoardType, size: Int) {
        
        _type = type
        _size = size
        reset()
        
    }
    
    mutating func changePlayer() {
        
        playerTurn = playerTurn < playerCount - 1 ? playerTurn + 1 : 0
        
    }
    
    public mutating func guess(toSquare s1: Square) throws { try validateGuess(s1: s1) }
    
    public mutating func guess(toSquare s1: Square, withGuess g1: Guess) throws { try validateGuess(s1: s1, g1) }
    
    public mutating func mark(toSquare s1: Square) throws { try validateMark(s1: s1) }
    
    public mutating func move(toSquare s1: Square) throws {
        
        try validateMove(s1: s1)
        
        changePlayer()
        
    }
    
    public mutating func move(pieceAt s1: Square, toSquare s2: Square) throws -> Piece? {
        
        let piece = try validateMove(s1: s1,s2)
        
        changePlayer()
        
        return piece
        
    }
    
    public mutating func move(pieceAt s1: ChessSquare, toSquare s2: ChessSquare) throws -> Piece? {
        
        let cols = "abcdefgh".array()
        guard let c1 = cols.index(of: s1.0), let c2 = cols.index(of: s2.0) else { return nil }
        let r1 = 8 - s1.1, r2 = 8 - s2.1
        
        let piece = try validateMove(s1: (r1,c1),(r2,c2))
        
        changePlayer()
        
        return piece
        
    }
    
    public mutating func reset(testing: Bool = false) {
        
        highlights = []
        selected = nil
        
        switch _type {
            
        case .Checkers:
            
            grid = Checkers.board
            playerPieces = Checkers.playerPieces
            
        case .Chess:
            
            grid = Chess.board
            playerPieces = Chess.playerPieces
            
        case .Go:
            
            grid = Go.board
            playerPieces = Go.playerPieces
            
        case .Mancala: break
            
        case .Minesweeper:
            
            solution = Minesweeper.board
            grid = Minesweeper.field
            playerPieces = Minesweeper.playerPieces
            
            guard testing else { break }
            
            solution = Minesweeper.staticboard
            playerPieces = Minesweeper.playerPieces
            
        case .Sudoku:
            
            solution = Sudoku.board
            grid = Sudoku.puzzle(grid: solution)
            playerPieces = Sudoku.playerPieces
            
            guard testing else { break }
            
            solution = Sudoku.staticboard
            grid = Sudoku.staticpuzzle(grid: solution)
            playerPieces = Sudoku.playerPieces
            
        case .TicTacToe:
            
            grid = TicTacToe.board
            playerPieces = TicTacToe.playerPieces
            
        }
        
    }
    
    public var highlights: [Square] = []
    public var selected: Square?
    
    public func visualize(rect: CGRect = CGRect(x: 0, y: 0, width: 200, height: 200)) -> UIView {
        
        switch _type {
            
        case .Checkers, .Chess: return grid.checker(rect: rect, highlights: highlights, selected: selected)
        case .Go: return grid.go(rect: rect)
        case .Mancala: return UIView()
        case .Minesweeper: return grid.mine(rect: rect)
        case .Sudoku: return grid.sudoku(rect: rect, highlights: highlights)
        case .TicTacToe: return grid.ttt(rect: rect)
            
        }
        
    }
    
}

extension Gameboard {
    
    public mutating func showAvailable(s1: Square) {
        
        highlights = []
        
        switch _type {
            
        case .Go, .Mancala, .Minesweeper, .Sudoku, .TicTacToe: break
            
        case .Chess, .Checkers:
            
            selected = nil
            
            for r in grid.rowRange.lowerBound...grid.rowRange.upperBound {
                
                for c in grid.colRange.lowerBound...grid.colRange.upperBound {
                    
                    guard let _ = try? validateMove(s1: s1,(r,c), true) else { continue }
                    selected = s1
                    highlights.append((r,c))
                    
                }
                
            }
            
        }
        
    }
    
    public mutating func showAvailable(s1: ChessSquare) {
        
        let cols: [String] = "abcdefgh".characters.map { "\($0)" }
        guard let c1 = cols.index(of: s1.0) else { return }
        let r1 = 8 - s1.1
        
        showAvailable(s1: (r1,c1))
        
    }
    
}

extension Gameboard {
    
    func validateNotFriendlyFire(p1: Piece, _ p2: Piece) throws -> Bool {
        
        var _player1: Int?
        var _player2: Int?
        
        for (p,pieces) in playerPieces.enumerated() {
            
            if pieces.contains(p1) { _player1 = p }
            if pieces.contains(p2) { _player2 = p }
            
        }
        
        guard let player1 = _player1 else { throw MoveError.NoPlayer }
        
        if let player2 = _player2 {
            
            guard player1 != player2 else { throw MoveError.FriendlyFire }
            
        }
        
        return true
        
    }
    
    func validatePlayer(piece: Piece) -> Bool {
        
        return playerPieces[playerTurn].contains(piece)
        
    }
    
    // moves, guesses, etc
    
    mutating func validateGuess(s1: Square) throws {
        
        guard grid.onBoard(s1: s1) else { throw MoveError.OutOfBounds }
        
        switch _type {
            
        case .Checkers, .Chess, .Go, .Mancala, .Sudoku, .TicTacToe: throw MoveError.IncorrectPiece
        case .Minesweeper: try Minesweeper.validateGuess(s1: s1, grid: solution, solution: grid)
            
        }
        
    }
    
    mutating func validateGuess(s1: Square, _ g1: Guess) throws {
        
        guard grid.onBoard(s1: s1) else { throw MoveError.OutOfBounds }
        
        switch _type {
            
        case .Checkers, .Chess, .Go, .Mancala, .Minesweeper, .TicTacToe: throw MoveError.IncorrectPiece
        case .Sudoku: try Sudoku.validateGuess(s1: s1, g1: g1, grid: grid, solution: solution)
            
        }
        
        highlights.append(s1)
        
    }
    
    mutating func validateMark(s1: Square) throws {
        
        guard grid.onBoard(s1: s1) else { throw MoveError.OutOfBounds }
        
        switch _type {
            
        case .Checkers, .Chess, .Go, .Mancala, .Sudoku, .TicTacToe: throw MoveError.IncorrectPiece
        case .Minesweeper: try Minesweeper.validateMark(s1: s1, grid: solution, solution: grid)
            
        }
        
    }
    
    mutating func validateMove(s1: Square) throws {
        
        guard grid.onBoard(s1: s1) else { throw MoveError.OutOfBounds }
        
        guard let p1 = grid[s1.0,s1.1] as? Piece else { throw MoveError.IncorrectPiece }
        
        switch _type {
            
        case .Checkers, .Chess, .Mancala, .Minesweeper, .Sudoku: throw MoveError.IncorrectPiece
        case .Go: try Go.validateMove(s1: s1, p1: p1, grid: grid, player: playerTurn)
        case .TicTacToe: try TicTacToe.validateMove(s1: s1, p1: p1, grid: grid, player: playerTurn)
            
        }
        
    }
    
    mutating func validateMove(s1: Square, _ s2: Square, _ hint: Bool = false) throws -> Piece? {
        
        guard grid.onBoard(s1: s1, s2) else { throw MoveError.OutOfBounds }
        
        guard let p1 = grid[s1.0,s1.1] as? Piece else { throw MoveError.IncorrectPiece }
        guard let p2 = grid[s2.0,s2.1] as? Piece else { throw MoveError.IncorrectPiece }
        
        guard validatePlayer(piece: p1) else { throw MoveError.NotYourTurn }
        try validateNotFriendlyFire(p1: p1, p2)
        
        switch _type {
            
        case .Checkers: return try Checkers.validateMove(s1: s1, s2: s2, p1: p1, p2: p2, grid: grid, hint: hint)
        case .Chess: return try Chess.validateMove(s1: s1, s2: s2, p1: p1, p2: p2, grid: grid, hint: hint)
        case .Go, .Mancala, .Minesweeper, .Sudoku, .TicTacToe: throw MoveError.IncorrectPiece
            
        }
        
    }
    
}



var checkers = Gameboard(.Checkers)

// setup colors

var colors = BoardColors()

colors.background = UIColor(red:0.66, green:0.62, blue:0.48, alpha:1)
colors.foreground = UIColor(red:0.62, green:0.58, blue:0.44, alpha:1)

colors.player1 = UIColor(red:0.8, green:0.13, blue:0, alpha:1)
colors.player2 = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1)

colors.selected = UIColor.white
colors.highlight = UIColor.white

checkers.boardColors = colors

// collection of moves

let moves: [(Square,Square)] = [

    ((2,1),(3,2)), // move
    ((5,2),(4,3)), // move
    ((2,3),(3,4)), // move
    ((4,3),(2,1)), // jump
    ((2,5),(4,3)), // cannot jump yourself
    ((2,5),(3,4)), // cannot land on your own piece
    ((1,0),(2,1)), // cannot land on another piece

]

// loop moves

for move in moves {
    
    do {
        
        try checkers.move(pieceAt: move.0, toSquare: move.1)
    
    } catch {
        
        print(error)
    
    }
    
}

checkers.showAvailable((1,2))

checkers.visualize()









