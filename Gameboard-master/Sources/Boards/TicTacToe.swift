import UIKit

public struct TicTacToe {
    
    public static var board: Grid { return Grid(3 ✕ (3 ✕ ("" as AnyObject))) }
    
    public static let playerPieces = ["✕","○"]
    
    public static func validateMove(s1: Square, p1: Piece, grid: Grid, player: Int) throws {
        
        guard p1 == "" else { throw MoveError.InvalidMove }
        
        grid[s1.0,s1.1] = playerPieces[player] as AnyObject // place my piece in target square
        
    }
    
}
