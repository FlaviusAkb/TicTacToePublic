//
//  Alerts.swift
//  TicTacToe
//
//  Created by Flavius Lucian Ilie on 15.08.2023.
//

import SwiftUI
private var viewModel = GameViewModel()
struct AlertItem: Identifiable {
	
	let id = UUID()
	var title: Text
	var message: Text
	var buttonTitle: Text
}

struct AlertContext {
	static let playerOneWin = AlertItem(title: Text("Game over!"),
							 message: Text("\(viewModel.player1Name) WON"),
							 buttonTitle: Text("Rematch!"))
	
	static let playerTwoWin = AlertItem(title: Text("Game over!"),
						   message: Text("\(viewModel.player2Name) WON"),
							 buttonTitle: Text("Rematch!"))
	
	static let draw = AlertItem(title: Text("Draw!"),
							 message: Text("What a match"),
							 buttonTitle: Text("Try again!"))
}
