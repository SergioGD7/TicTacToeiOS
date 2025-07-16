//
// TicTacToeView.swift
// TicTacToe
//
// Created by Sergio González Díaz on 4/7/25.
//

import SwiftUI

struct TicTacToeView: View {
    @ObservedObject var rankingManager: RankingManager
    @StateObject private var viewModel: TicTacToeViewModel
    @State private var showModeSelection = false
    @State private var showDifficultySelection = false
    
    init(rankingManager: RankingManager) {
        self.rankingManager = rankingManager
        self._viewModel = StateObject(wrappedValue: TicTacToeViewModel(rankingManager: rankingManager))
    }
    
    var body: some View {
        GeometryReader { geometry in
                    VStack {
                        // Header con título y modo actual
                        VStack(spacing: 10) {
                            Text("TIC TAC TOE")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            // Mostrar modo actual y dificultad
                            HStack {
                                Text(viewModel.gameMode == .vsComputer ? "Vs Computadora" : "Vs Jugador")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                
                                Button("Cambiar") {
                                    showModeSelection = true
                                }
                                .font(.caption)
                                .foregroundColor(.blue)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                            }
                            
                            // Mostrar dificultad solo en modo vs computadora
                            if viewModel.gameMode == .vsComputer {
                                HStack {
                                    Text("Dificultad: \(viewModel.difficulty.displayName)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    Button("Cambiar") {
                                        showDifficultySelection = true
                                    }
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                                }
                            }
                        }
                        .padding()
                
                // Mostrar información del turno actual
                Text(viewModel.getCurrentPlayerName())
                    .font(.headline)
                    .foregroundColor(viewModel.currentPlayer == .playerOne || viewModel.currentPlayer == .human ? .red : .blue)
                    .padding(.bottom)
                
                // Mostrar intentos solo en modo vs computadora
                if viewModel.gameMode == .vsComputer {
                    Text("Intentos: \(viewModel.gameAttempts)")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding(.bottom)
                }
                
                Spacer()
                
                // Tablero de juego 3x3
                LazyVGrid(columns: viewModel.columns, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack {
                            // Fondo azul del cuadrado
                            Rectangle()
                                .foregroundColor(.blue)
                                .opacity(0.9)
                                .frame(
                                    width: geometry.size.width/3 - 15,
                                    height: geometry.size.width/3 - 15
                                )
                                .cornerRadius(15)
                            
                            // Cuadrado blanco interior
                            Rectangle()
                                .foregroundColor(.white)
                                .frame(
                                    width: geometry.size.width/3 - 30,
                                    height: geometry.size.width/3 - 30
                                )
                                .cornerRadius(10)
                            
                            // Mostrar X u O si hay movimiento
                            if let move = viewModel.moves[i] {
                                Text(move.indicator)
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(move.indicator == "X" ? .red : .blue)
                            }
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i)
                        }
                    }
                }
                
                Spacer()
                
                Button("Nueva Partida") {
                    viewModel.startNewGame()
                }
                .font(.title2)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .padding()
            }
            .disabled(viewModel.isGameBoardDisabled)
            .padding()
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(
                    title: alertItem.title,
                    message: alertItem.message,
                    dismissButton: .default(alertItem.buttonTitle) {
                        viewModel.resetGame()
                    }
                )
            }
            .sheet(isPresented: $viewModel.showNameInput) {
                NameInputView(viewModel: viewModel)
            }
            .sheet(isPresented: $showModeSelection) {
                GameModeSelectionView(viewModel: viewModel, showModeSelection: $showModeSelection)
            }
            .sheet(isPresented: $showDifficultySelection) {
                DifficultySelectionView(viewModel: viewModel, showDifficultySelection: $showDifficultySelection)
            }
        }
    }
}

struct NameInputView: View {
    @ObservedObject var viewModel: TicTacToeViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("¡GANASTE!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                
                Text("Completaste el juego en \(viewModel.gameAttempts) intentos")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                TextField("Ingresa tu nombre", text: $viewModel.playerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Guardar Puntuación") {
                    viewModel.saveScore()
                }
                .font(.title2)
                .foregroundColor(.white)
                .padding()
                .background(viewModel.playerName.isEmpty ? Color.gray : Color.blue)
                .cornerRadius(10)
                .disabled(viewModel.playerName.isEmpty)
            }
            .padding()
            .navigationTitle("Nueva Puntuación")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
