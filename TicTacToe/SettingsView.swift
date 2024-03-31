//
//  SettingsView.swift
//  TicTacToe
//
//  Created by Flavius Lucian Ilie on 15.08.2023.
//

import SwiftUI

struct SettingsView: View {
	@ObservedObject var matches: Matches
	@StateObject private var viewModel = GameViewModel()
	@Environment(\.dismiss) var dismiss
	
	var body: some View {
		NavigationView {
			VStack {
				HStack {
					
					Image(systemName: "person")
					TextField("Player 1 name: \(viewModel.player1Name)", text: $viewModel.player1Name)
					
					Toggle(viewModel.matchVSAI ? "VS AI \(Image(systemName: "face.smiling"))" : "VS", isOn: $viewModel.matchVSAI)
						.toggleStyle(.button)
					if !viewModel.matchVSAI {
						Image(systemName: "person")
						TextField("Player 2 name:\(viewModel.player2Name)", text: $viewModel.player2Name)
					}
				}
				.padding()
				if viewModel.matchVSAI {
					VStack{
						
						Text("Please select AI level:")
						Text("\(viewModel.aiLevels[viewModel.vsAILvl])")
							.italic()
						Picker("AI level:", selection: $viewModel.vsAILvl) {
							ForEach((1...3), id: \.self) {
								Text("\($0)")
							}
						}
						.pickerStyle(.segmented)
						
					}
				}
				Text("Latest match winners:")
					.font(.title)
					.padding()
				List {
					ForEach(matches.items) { item in
						Text("\(item.match) -- \(item.result) ")
					}
				}
				.listStyle(.inset)
				
			}
			.navigationTitle("Set up your game")
			.alert("Clear saved results also?", isPresented: $viewModel.emptyResults) {
				Button("Yes") {
					matches.items.removeAll()
					viewModel.emptyResults = false
				}
				Button("No") {
					dismiss()
				}
			}
			.toolbar {
				Button("Save") {
					if viewModel.matchVSAI {
						viewModel.player2Name = "AI (\(viewModel.aiLevels[viewModel.vsAILvl]))"
					}
					dismiss()
				}
				
				Button("Reset") {
					viewModel.player1Name = "Player 1"
					viewModel.player2Name = "AI"
					viewModel.matchVSAI = true
					viewModel.emptyResults = true
					
					
				}
			}
			
			
		}
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView(matches: Matches())
	}
}
