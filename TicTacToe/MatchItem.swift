//
//  MatchItem.swift
//  TicTacToe
//
//  Created by Flavius Lucian Ilie on 15.08.2023.
//

import Foundation

struct MatchItem: Identifiable, Codable {
	var id = UUID()
	let match: String
	let result: String
}
