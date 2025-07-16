//
//  TicTacToeViewModel.swift
//  TicTacToe
//
//  Created by Sergio González Díaz on 4/7/25.
//

import SwiftUI

final class TicTacToeViewModel: ObservableObject {
    // Configuración de columnas para el grid
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // Array de movimientos (nil = casilla vacía)
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisabled = false
    @Published var alertItem: AlertItem?
    
    // Procesar movimiento del jugador
    func processPlayerMove(for position: Int) {
        // Verificar si la casilla está ocupada
        if isSquareOccupied(in: moves, forIndex: position) { return }
        
        // Realizar movimiento humano
        moves[position] = Move(player: .human, boardIndex: position)
        
        // Verificar victoria humana
        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertContent.humanWins
            return
        }
        
        // Verificar empate
        if checkForDraw(in: moves) {
            alertItem = AlertContent.draw
            return
        }
        
        // Deshabilitar tablero para movimiento de computadora
        isGameBoardDisabled = true
        
        // Movimiento de computadora con delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            isGameBoardDisabled = false
            
            // Verificar victoria de computadora
            if checkWinCondition(for: .computer, in: moves) {
                alertItem = AlertContent.computerWins
                return
            }
            
            // Verificar empate después del movimiento de computadora
            if checkForDraw(in: moves) {
                alertItem = AlertContent.draw
                return
            }
        }
    }
    
    // Verificar si una casilla está ocupada
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    // Determinar posición aleatoria para computadora
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        let occupiedIndices = Set(moves.compactMap { $0?.boardIndex })
        let allIndices = Set(0..<9)
        let unoccupiedIndices = allIndices.subtracting(occupiedIndices)
        return unoccupiedIndices.randomElement()!
    }
    
    // Verificar condición de victoria
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [
            [0,1,2], [3,4,5], [6,7,8], // Horizontales
            [0,3,6], [1,4,7], [2,5,8], // Verticales
            [0,4,8], [2,4,6]           // Diagonales
        ]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) {
            return true
        }
        return false
    }
    
    // Verificar empate
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    // Reiniciar juego
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
        isGameBoardDisabled = false
    }
}

// Enumeración para jugadores
enum Player {
    case human, computer
}

// Estructura para movimientos
struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "X" : "O"
    }
}
