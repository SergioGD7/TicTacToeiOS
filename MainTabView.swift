//
// MainTabView.swift
// TicTacToe
//
// Created by Sergio González Díaz on 4/7/25.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var rankingManager = RankingManager()
    
    var body: some View {
        TabView {
            TicTacToeView(rankingManager: rankingManager)
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Juego")
                }
            
            RankingView(rankingManager: rankingManager)
                .tabItem {
                    Image(systemName: "trophy")
                    Text("Ranking")
                }
        }
        .accentColor(.blue)
    }
}

#Preview {
    MainTabView()
}

