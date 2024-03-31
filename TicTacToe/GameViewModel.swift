//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Flavius Lucian Ilie on 15.08.2023.
//

import SwiftUI

final class GameViewModel: ObservableObject {
	let columns: [GridItem] = [GridItem(.flexible()),
							   GridItem(.flexible()),
							   GridItem(.flexible())]
	
	
	@Published var moves: [Move?] = Array(repeating: nil, count: 9)
	@Published var isGameboardDisabled = false
	@Published var alertItem: AlertItem?
	@Published var gameResult = ""
	@Published var emptyResults = false
	
	@Published var matches = Matches()
	
	@AppStorage("p1") var player1Name = "Player 1" {
		willSet { objectWillChange.send() }
	}
	@AppStorage("p2") var player2Name = "AI" {
		willSet { objectWillChange.send() }
	}
	@AppStorage("vsAI") var matchVSAI = true {
		willSet { objectWillChange.send() }
	}
	@AppStorage("vsAILvl") var vsAILvl = 3 {
		willSet { objectWillChange.send() }
	}
	@AppStorage("playerOneTurn") var isPlayerOneTurn = true {
		willSet { objectWillChange.send() }
	}
	@Published var aiLevels = ["0", "easy", "medium", "hard"]
	
	func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
		return moves.contains(where: {$0?.boardIndex == index})
	}
	
	func processPlayerMoves(for position: Int) {
		if isPlayerOneTurn {
			if isSquareOccupied(in: moves, forIndex: position) { return }
			moves[position] = Move(player: .playerOne, boardIndex: position)
			
			
			print("Player 1 selected: \(position)")
			// win or draw
			if checkWinCondition(for: .playerOne, in: moves) {
				gameResult = "\(player1Name)"
				saveResult()
				alertItem = AlertContext.playerOneWin
				return
			}
			
			if checkForDraw(in: moves) {
				gameResult = "Draw"
				saveResult()
				alertItem = AlertContext.draw
				return
			}
			isPlayerOneTurn = false
			
		}
		
		if matchVSAI {
			
			isGameboardDisabled = true
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
				let playerTwoPosition = determinePlayerTwoMovePosition(in: moves)
				moves[playerTwoPosition] = Move(player: .playerTwo, boardIndex: playerTwoPosition)
				isGameboardDisabled = false
				print("AI selected: \(playerTwoPosition)")
				isPlayerOneTurn = true
				
				// win or draw
				if checkWinCondition(for: .playerTwo, in: moves) {
					gameResult = "\(player2Name)!"
					saveResult()
					alertItem = AlertContext.playerTwoWin
					return
				}
				
				if checkForDraw(in: moves) {
					gameResult = "Draw"
					saveResult()
					alertItem = AlertContext.draw
					return
				}
			}
			
		} else {
			if isSquareOccupied(in: moves, forIndex: position) { return }
			let playerTwoPosition = position
			moves[playerTwoPosition] = Move(player: .playerTwo, boardIndex: playerTwoPosition)
			print("Player 2 selected: \(playerTwoPosition)")
			isPlayerOneTurn = true
			
			// win or draw
			if checkWinCondition(for: .playerTwo, in: moves) {
				gameResult = "\(player2Name)"
				saveResult()
				alertItem = AlertContext.playerTwoWin
				return
			}
			
			if checkForDraw(in: moves) {
				gameResult = "Draw"
				saveResult()
				alertItem = AlertContext.draw
				return
			}
		}
		
//		// win or draw
//		if checkWinCondition(for: .playerTwo, in: moves) {
//			gameResult = "P2"
//			alertItem = AlertContext.playerTwoWin
//			return
//		}
//		
//		if checkForDraw(in: moves) {
//			gameResult = "D"
//			saveResult()
//			alertItem = AlertContext.draw
//			return
//		}
		
	}
	func saveResult() {
		let item = MatchItem(match: "\(player1Name) vs \(player2Name)", result: gameResult)
		matches.items.append(item)
	}
	
	func determinePlayerTwoMovePosition(in moves: [Move?]) -> Int {
		
		// 1. if AI can win, then win
		
		let winPattern: Set<Set<Int>> = [ [0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6] ]
		// remove nils
		let playerTwoMoves = moves.compactMap { $0 }.filter { $0.player == .playerTwo }
		
		let playerTwoPositions = playerTwoMoves.map{ $0.boardIndex }
		
		for pattern in winPattern {
			// there is a chance to win if after substracting the playerTwoPositions there is only one other move needed
			// ex if the playerTwo has already [0, 1] he only needs [2] to win so it will go for that if it's available
			let winPositions = pattern.subtracting(playerTwoPositions)
			
			if winPositions.count == 1 {
				let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
				if isAvailable { return winPositions.first! }
			}
		}
		if vsAILvl > 2 {
			// 2. if AI can't win, then block
			let humanMoves = moves.compactMap { $0 }.filter { $0.player == .playerOne }
			
			let humanPositions = humanMoves.map{ $0.boardIndex }
			
			for pattern in winPattern {
				// there is a chance to win if after substracting the playerTwoPositions there is only one other move needed
				// ex if the playerTwo has already [0, 1] he only needs [2] to win so it will go for that if it's available
				let winPositions = pattern.subtracting(humanPositions)
				
				if winPositions.count == 1 {
					let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
					if isAvailable { return winPositions.first! }
				}
			}
		}
		if vsAILvl > 1 {
			// 3. if AI can't block then take middle
			let centerSquare = 4
			if !isSquareOccupied(in: moves, forIndex: centerSquare) {
				return centerSquare
			}
			
		}
		// 4. if can't take middle, take random
		
		
		var movePosition = Int.random(in: 0..<9)
		
		while isSquareOccupied(in: moves, forIndex: movePosition) {
			movePosition = Int.random(in: 0..<9)
		}
		return movePosition
	}
	
	func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
		let winPattern: Set<Set<Int>> = [ [0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6] ]
		// remove nils
		let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
		
		let playerPositions = playerMoves.map{ $0.boardIndex }
		print("\(player) has \(playerPositions)")
		// check if playerPositions is in win pattern
		for pattern in winPattern where pattern.isSubset(of: playerPositions){ return true }
		
		return false
	}
	
	func checkForDraw(in moves:[Move?]) -> Bool {
		return moves.compactMap{ $0 }.count == 9
	}
	
	func resetGame() {
		moves = Array(repeating: nil, count: 9)
		isPlayerOneTurn = true
	}
}
