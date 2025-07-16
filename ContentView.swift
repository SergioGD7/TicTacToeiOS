//
// ContentView.swift
// TicTacToe
//
// Created by Sergio González Díaz on 4/7/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var rankingManager = RankingManager()
    
    var body: some View {
        TicTacToeView(rankingManager: rankingManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

