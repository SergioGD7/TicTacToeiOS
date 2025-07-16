//
//  GameScore.swift
//  TicTacToe
//
//  Created by Sergio González Díaz on 14/7/25.
//

import Foundation

struct GameScore: Identifiable, Codable {
    let id = UUID()
    let playerName: String
    let attempts: Int
    let date: Date
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

class RankingManager: ObservableObject {
    @Published var scores: [GameScore] = []
    private let userDefaults = UserDefaults.standard
    private let scoresKey = "TicTacToeScores"
    
    init() {
        loadScores()
    }
    
    func addScore(playerName: String, attempts: Int) {
        let newScore = GameScore(playerName: playerName, attempts: attempts, date: Date())
        scores.append(newScore)
        scores.sort { $0.attempts < $1.attempts }
        // Mantener solo los 10 mejores
        if scores.count > 10 {
            scores = Array(scores.prefix(10))
        }
        
        saveScores()
    }
    
    private func saveScores() {
        if let encoded = try? JSONEncoder().encode(scores) {
            userDefaults.set(encoded, forKey: scoresKey)
        }
    }
    
    // Hacer público este método
    func loadScores() {
        if let data = userDefaults.data(forKey: scoresKey),
           let decoded = try? JSONDecoder().decode([GameScore].self, from: data) {
            scores = decoded.sorted { $0.attempts < $1.attempts }
        }
    }
    
    func clearScores() {
        scores.removeAll()
        saveScores()
    }
}

