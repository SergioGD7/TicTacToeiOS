//
//  TicTacToeView.swift
//  TicTacToe
//
//  Created by Sergio González Díaz on 4/7/25.
//

import SwiftUI

struct TicTacToeView: View {
    @StateObject private var viewModel = TicTacToeViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("TIC TAC TOE")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
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
                                    .foregroundColor(move.player == .human ? .red : .blue)
                            }
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i)
                        }
                    }
                }
                
                Spacer()
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
        }
    }
}
