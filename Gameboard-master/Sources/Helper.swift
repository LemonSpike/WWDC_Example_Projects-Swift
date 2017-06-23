import UIKit

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
