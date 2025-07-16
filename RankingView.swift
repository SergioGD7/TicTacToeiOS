//
// RankingView.swift
// TicTacToe
//
// Created by Sergio González Díaz on 4/7/25.
//

import SwiftUI

struct RankingView: View {
    @ObservedObject var rankingManager: RankingManager
    
    var body: some View {
        NavigationView {
            VStack {
                if rankingManager.scores.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "trophy.circle")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                        
                        Text("No hay puntuaciones aún")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        Text("¡Juega algunas partidas para ver tu ranking!")
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(Array(rankingManager.scores.enumerated()), id: \.element.id) { index, score in
                            HStack {
                                // Posición
                                ZStack {
                                    Circle()
                                        .fill(positionColor(for: index))
                                        .frame(width: 30, height: 30)
                                    
                                    Text("\(index + 1)")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(score.playerName)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Text(score.formattedDate)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Text("\(score.attempts)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                    
                                    Text("intentos")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("🏆 Ranking")
            .toolbar {
                if !rankingManager.scores.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Limpiar") {
                            rankingManager.clearScores()
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .onAppear {
                // Recargar datos correctamente
                rankingManager.loadScores()
            }
        }
    }
    
    private func positionColor(for index: Int) -> Color {
        switch index {
        case 0: return .yellow // Oro
        case 1: return .gray // Plata
        case 2: return .orange // Bronce
        default: return .blue
        }
    }
}
