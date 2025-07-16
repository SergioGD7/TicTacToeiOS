//
// GameModeSelectionView.swift
// TicTacToe
//
// Created by Sergio González Díaz on 4/7/25.
//

import SwiftUI

struct GameModeSelectionView: View {
    @ObservedObject var viewModel: TicTacToeViewModel
    @Binding var showModeSelection: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Selecciona el Modo de Juego")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 20) {
                // Botón vs Computadora
                Button(action: {
                    viewModel.setGameMode(.vsComputer)
                    showModeSelection = false
                }) {
                    HStack {
                        Image(systemName: "desktopcomputer")
                            .font(.title2)
                        
                        VStack(alignment: .leading) {
                            Text("Vs Computadora")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text("Juega contra la IA")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if viewModel.gameMode == .vsComputer {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(viewModel.gameMode == .vsComputer ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(viewModel.gameMode == .vsComputer ? Color.blue : Color.clear, lineWidth: 2)
                    )
                }
                .foregroundColor(.primary)
                
                // Botón vs Jugador
                Button(action: {
                    viewModel.setGameMode(.vsPlayer)
                    showModeSelection = false
                }) {
                    HStack {
                        Image(systemName: "person.2")
                            .font(.title2)
                        
                        VStack(alignment: .leading) {
                            Text("Vs Jugador")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text("Juega contra otro jugador")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if viewModel.gameMode == .vsPlayer {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(viewModel.gameMode == .vsPlayer ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(viewModel.gameMode == .vsPlayer ? Color.blue : Color.clear, lineWidth: 2)
                    )
                }
                .foregroundColor(.primary)
            }
            
            Button("Cerrar") {
                showModeSelection = false
            }
            .font(.headline)
            .foregroundColor(.blue)
            .padding()
        }
        .padding()
    }
}
