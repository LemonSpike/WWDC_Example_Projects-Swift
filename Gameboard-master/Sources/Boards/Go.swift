import UIKit

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
