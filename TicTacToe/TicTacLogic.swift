//
//  TicTacLogic.swift
//  TicTacToe
//
//  Created by Леонид on 19.12.2022.
//

import Foundation

class TicTacLogic {
    @Published var boardUi: [Board] = []
    typealias Move = Int
    
    enum Piece: String {
        case X = "X"
        case O = "O"
        case E = " "
        var opposite: Piece {
            switch self {
                case .X:
                    return .O
                case .O:
                    return .X
                case .E:
                    return .E
            }
        }
    }
    
    struct Board {
        let position: [Piece]
        let turn: Piece
        let lastMove: Move
        init(position: [Piece] = [.E, .E, .E, .E, .E, .E, .E, .E, .E], turn: Piece = .X, lastMove: Int = -1) {
            self.position = position
            self.turn = turn
            self.lastMove = lastMove
        }
        
        func move(_ location: Move) -> Board {
            var tempPosition = position
            tempPosition[location] = turn
            return Board(position: tempPosition, turn: turn.opposite, lastMove: location)
        }
        var legalMoves: [Move] {
            return position.indices.filter { position[$0] == .E }
        }
        var isWin: Bool {
            return
            position[0] == position[1] && position[0] == position[2] && position[0] != .E ||
            position[3] == position[4] && position[3] == position[5] && position[3] != .E ||
            position[6] == position[7] && position[6] == position[8] && position[6] != .E ||
            position[0] == position[3] && position[0] == position[6] && position[0] != .E ||
            position[1] == position[4] && position[1] == position[7] && position[1] != .E ||
            position[2] == position[5] && position[2] == position[8] && position[2] != .E ||
            position[0] == position[4] && position[0] == position[8] && position[0] != .E ||
            position[2] == position[4] && position[2] == position[6] && position[2] != .E
            
        }
        
        var isDraw: Bool {
            return !isWin && legalMoves.count == 0
        }
        
        func minimax(_ board: Board, maximizing: Bool, originalPlayer: Piece) -> Int {
            if board.isWin && originalPlayer == board.turn.opposite { return 1 }
            else if board.isWin && originalPlayer != board.turn.opposite { return -1 }
            else if board.isDraw { return 0 }
            
            if maximizing {
                var bestEval = Int.min
                for move in board.legalMoves {
                    let result = minimax(board.move(move), maximizing: false, originalPlayer: originalPlayer)
                    bestEval = max(result, bestEval)
                }
                return bestEval
            } else {
                var worstEval = Int.max
                for move in board.legalMoves {
                    let result = minimax(board.move(move), maximizing: true, originalPlayer: originalPlayer)
                    worstEval = min(result, worstEval)
                }
                return worstEval
            }
        }
        
        func findBestMove(_ board: Board) -> Move {
            var bestEval = Int.min
            var bestMove = -1
            for move in board.legalMoves {
                let result = minimax(board.move(move), maximizing: false, originalPlayer: board.turn)
                if result > bestEval {
                    bestEval = result
                    bestMove = move
                }
            }
            return bestMove
        }
    }
}


