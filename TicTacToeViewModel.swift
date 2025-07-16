//
// TicTacToeViewModel.swift
// TicTacToe
//
// Created by Sergio González Díaz on 4/7/25.
//

import SwiftUI

// Enumeración para el modo de juego
enum GameMode {
    case vsComputer
    case vsPlayer
}

// Enumeración para jugadores
enum Player {
    case human, computer, playerOne, playerTwo
}

// Enumeración para dificultad de la IA
enum Difficulty {
    case easy
    case normal
    case hard
    
    var displayName: String {
        switch self {
        case .easy: return "Fácil"
        case .normal: return "Normal"
        case .hard: return "Difícil"
        }
    }
}


// Estructura para movimientos
struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        switch player {
        case .human, .playerOne:
            return "X"
        case .computer, .playerTwo:
            return "O"
        }
    }
}

final class TicTacToeViewModel: ObservableObject {
    // Configuración de columnas para el grid
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Published var difficulty: Difficulty = .normal
    // Array de movimientos (nil = casilla vacía)
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisabled = false
    @Published var alertItem: AlertItem?
    @Published var gameAttempts = 0
    @Published var showNameInput = false
    @Published var playerName = ""
    @Published var gameMode: GameMode = .vsComputer
    @Published var currentPlayer: Player = .human
    
    // Instancia compartida del ranking manager
    let rankingManager: RankingManager
    
    init(rankingManager: RankingManager) {
        self.rankingManager = rankingManager
    }
    
    // Función para cambiar dificultad
    func setDifficulty(_ newDifficulty: Difficulty) {
        difficulty = newDifficulty
    }
    
    // Determinar posición de la computadora según dificultad
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        switch difficulty {
        case .easy:
            return easyMode(in: moves)
        case .normal:
            return normalMode(in: moves)
        case .hard:
            return hardMode(in: moves)
        }
    }
    
    // Modo fácil: 70% movimientos aleatorios, 30% estratégicos
        private func easyMode(in moves: [Move?]) -> Int {
            let randomChoice = Int.random(in: 1...100)
            
            if randomChoice <= 70 {
                return randomMove(in: moves)
            } else {
                return strategicMove(in: moves)
            }
        }
        
        // Modo normal: 50% movimientos aleatorios, 50% estratégicos
        private func normalMode(in moves: [Move?]) -> Int {
            let randomChoice = Int.random(in: 1...100)
            
            if randomChoice <= 50 {
                return randomMove(in: moves)
            } else {
                return strategicMove(in: moves)
            }
        }
        
        // Modo difícil: 100% movimientos estratégicos
        private func hardMode(in moves: [Move?]) -> Int {
            return strategicMove(in: moves)
        }
        
        // Movimiento aleatorio
        private func randomMove(in moves: [Move?]) -> Int {
            let occupiedIndices = Set(moves.compactMap { $0?.boardIndex })
            let allIndices = Set(0..<9)
            let unoccupiedIndices = allIndices.subtracting(occupiedIndices)
            return unoccupiedIndices.randomElement()!
        }
        
    // Movimiento estratégico usando algoritmo minimax simplificado
    private func strategicMove(in moves: [Move?]) -> Int {
        let occupiedIndices = Set(moves.compactMap { $0?.boardIndex })
        let allIndices = Set(0..<9)
        let unoccupiedIndices = allIndices.subtracting(occupiedIndices)
            
        // 1. Intentar ganar
        for position in unoccupiedIndices {
            var testMoves = moves
            testMoves[position] = Move(player: .computer, boardIndex: position)
            if checkWinCondition(for: .computer, in: testMoves) {
                return position
            }
        }
            
        // 2. Bloquear al jugador
        for position in unoccupiedIndices {
            var testMoves = moves
            testMoves[position] = Move(player: .human, boardIndex: position)
            if checkWinCondition(for: .human, in: testMoves) {
                return position
            }
        }
            
        // 3. Tomar el centro si está disponible
        if unoccupiedIndices.contains(4) {
            return 4
        }
            
        // 4. Tomar una esquina
        let corners = [0, 2, 6, 8]
        let availableCorners = corners.filter { unoccupiedIndices.contains($0) }
        if !availableCorners.isEmpty {
            return availableCorners.randomElement()!
        }
            
        // 5. Tomar cualquier posición disponible
        return unoccupiedIndices.randomElement()!
    }
    
    // Cambiar modo de juego
    func setGameMode(_ mode: GameMode) {
        gameMode = mode
        resetGame()
        
        // Establecer el jugador inicial según el modo
        currentPlayer = mode == .vsComputer ? .human : .playerOne
    }
    
    // Procesar movimiento del jugador
    func processPlayerMove(for position: Int) {
        // Verificar si la casilla está ocupada
        if isSquareOccupied(in: moves, forIndex: position) { return }
        
        // INCREMENTAR INTENTOS solo en modo vs computadora
        if gameMode == .vsComputer {
            gameAttempts += 1
        }
        
        // Realizar movimiento del jugador actual
        moves[position] = Move(player: currentPlayer, boardIndex: position)
        
        // Verificar victoria
        if checkWinCondition(for: currentPlayer, in: moves) {
            handleWin(for: currentPlayer)
            return
        }
        
        // Verificar empate
        if checkForDraw(in: moves) {
            alertItem = AlertContent.draw
            return
        }
        
        // Cambiar de jugador según el modo
        if gameMode == .vsComputer {
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
        } else {
            // Modo vs jugador: alternar entre jugadores
            currentPlayer = currentPlayer == .playerOne ? .playerTwo : .playerOne
        }
    }
    
    // Manejar victoria
    private func handleWin(for player: Player) {
        switch player {
        case .human:
            showNameInput = true
        case .computer:
            alertItem = AlertContent.computerWins
        case .playerOne:
            alertItem = AlertContent.playerOneWins
        case .playerTwo:
            alertItem = AlertContent.playerTwoWins
        }
    }
    
    // Verificar si una casilla está ocupada
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
        
    // Verificar condición de victoria
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [
            [0,1,2], [3,4,5], [6,7,8], // Horizontales
            [0,3,6], [1,4,7], [2,5,8], // Verticales
            [0,4,8], [2,4,6] // Diagonales
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
        gameAttempts = 0
        currentPlayer = gameMode == .vsComputer ? .human : .playerOne
    }
    
    // Guardar puntuación (solo para modo vs computadora)
    func saveScore() {
        if !playerName.isEmpty && gameMode == .vsComputer {
            rankingManager.addScore(playerName: playerName, attempts: gameAttempts)
        }
        playerName = ""
        gameAttempts = 0
        showNameInput = false
        alertItem = AlertContent.humanWins
        
        resetGame()
    }
    
    // Iniciar nueva partida
    func startNewGame() {
        resetGame()
    }
    
    // Obtener nombre del jugador actual
    func getCurrentPlayerName() -> String {
        switch currentPlayer {
        case .human:
            return "Tu turno"
        case .computer:
            return "Turno de la computadora"
        case .playerOne:
            return "Turno del Jugador 1 (X)"
        case .playerTwo:
            return "Turno del Jugador 2 (O)"
        }
    }
}

