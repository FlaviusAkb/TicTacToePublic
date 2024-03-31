//
//  Settings.swift
//  TicTacToe
//
//  Created by Flavius Lucian Ilie on 15.08.2023.
//

import Foundation

class Settings: ObservableObject {
	@Published var items = [SettingsItem] () {
		// saving the data using a json encoder
		didSet {
			let encoder = JSONEncoder()
			
			if let encoded = try? encoder.encode(items) {
				UserDefaults.standard.set(encoded, forKey: "Items")
			}
		}
	}
	// loading the saved data using a custom initializer and a json decoder
	init() {
		// 1. Read data from the defaults, its optional so it could not exist, could be nil
		if let savedItems = UserDefaults.standard.data(forKey: "Items") {
			// 2. If we can read, try decoding it
			let decoder = JSONDecoder()
			if let decodedItems = try? decoder.decode([SettingsItem].self, from: savedItems) {
				
				//3. If the items were decoded set the items array as the decoded array
				items = decodedItems
				return
			}
		}
		// Else, set the items array as an empty array
		items = []
	}
}
