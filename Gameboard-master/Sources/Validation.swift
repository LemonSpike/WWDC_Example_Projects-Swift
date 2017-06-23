import UIKit

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
