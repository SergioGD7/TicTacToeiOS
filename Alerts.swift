//
// Alerts.swift
// TicTacToe
//
// Created by Sergio González Díaz on 4/7/25.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
} 

struct AlertContent {
    static let humanWins = AlertItem(
        title: Text("¡GANASTE!"),
        message: Text("Has vencido a la computadora"),
        buttonTitle: Text("Nueva Partida")
    )
    
    static let computerWins = AlertItem(
        title: Text("¡PERDISTE!"),
        message: Text("La computadora te ha vencido"),
        buttonTitle: Text("Nueva Partida")
    )
    
    static let playerOneWins = AlertItem(
        title: Text("¡JUGADOR 1 GANA!"),
        message: Text("El Jugador 1 (X) ha ganado la partida"),
        buttonTitle: Text("Nueva Partida")
    )
    
    static let playerTwoWins = AlertItem(
        title: Text("¡JUGADOR 2 GANA!"),
        message: Text("El Jugador 2 (O) ha ganado la partida"),
        buttonTitle: Text("Nueva Partida")
    )
    
    static let draw = AlertItem(
        title: Text("¡EMPATE!"),
        message: Text("La partida ha terminado en empate"),
        buttonTitle: Text("Nueva Partida")
    )
}
