//
// DifficultySelectionView.swift
// TicTacToe
//
// Created by Sergio González Díaz on 16/7/25.
//

import SwiftUI

struct DifficultySelectionView: View {
    @ObservedObject var viewModel: TicTacToeViewModel
    @Binding var showDifficultySelection: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Selecciona la Dificultad")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 20) {
                    // Botón Fácil
                    DifficultyButton(
                        title: "Fácil",
                        subtitle: "IA menos inteligente",
                        icon: "tortoise",
                        color: .green,
                        difficulty: .easy,
                        selectedDifficulty: viewModel.difficulty,
                        action: {
                            viewModel.setDifficulty(.easy)
                            showDifficultySelection = false
                        }
                    )

                    // Botón Normal
                    DifficultyButton(
                        title: "Normal",
                        subtitle: "IA balanceada",
                        icon: "hare",
                        color: .orange,
                        difficulty: .normal,
                        selectedDifficulty: viewModel.difficulty,
                        action: {
                            viewModel.setDifficulty(.normal)
                            showDifficultySelection = false
                        }
                    )

                    // Botón Difícil
                    DifficultyButton(
                        title: "Difícil",
                        subtitle: "IA muy inteligente",
                        icon: "bolt",
                        color: .red,
                        difficulty: .hard,
                        selectedDifficulty: viewModel.difficulty,
                        action: {
                            viewModel.setDifficulty(.hard)
                            showDifficultySelection = false
                        }
                    )
                }
                
                Button("Cerrar") {
                    showDifficultySelection = false
                }
                .font(.headline)
                .foregroundColor(.blue)
                .padding()
            }
            .padding()
            .navigationTitle("Dificultad")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DifficultyButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let difficulty: Difficulty
    let selectedDifficulty: Difficulty
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if selectedDifficulty == difficulty {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(selectedDifficulty == difficulty ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(selectedDifficulty == difficulty ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .foregroundColor(.primary)
    }
}
