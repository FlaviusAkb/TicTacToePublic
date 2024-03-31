//
//  Matches.swift
//  TicTacToe
//
//  Created by Flavius Lucian Ilie on 18.08.2023.
//

import Foundation

class Matches: ObservableObject {
	@Published var items = [MatchItem]() {
		didSet {
			let encoder = JSONEncoder()
			
			if let encoded = try? encoder.encode(items) {
				UserDefaults.standard.set(encoded, forKey: "Items")
			}
		}
	}
	init() {
		if let savedItems = UserDefaults.standard.data(forKey: "Items") {
			let decoder = JSONDecoder()
			
			if let decodedItems = try? decoder.decode([MatchItem].self, from: savedItems) {
				items = decodedItems
				return
			}
		}
		items = []
	}
}
