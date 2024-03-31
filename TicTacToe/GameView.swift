//
//  GameView.swift
//  TicTacToe
//
//  Created by Flavius Lucian Ilie on 15.08.2023.
//

import SwiftUI



struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    @State private var showingSettings = false
    
    var body: some View {
        
        GeometryReader { geometry in
            
            NavigationView {
                ZStack {
                    Image("background")
                        .resizable()
                        .ignoresSafeArea()
                    
                    VStack {
                        Spacer()
                        HStack {
                            Text(viewModel.player1Name)
                                .foregroundColor(Color.red)
                        }
                        .font(.title).bold()
                        LazyVGrid(columns: viewModel.columns, spacing: 1) {
                            
                            ForEach(0..<9) { i in
                                ZStack {
                                    GameSquareView(proxy: geometry)
                                    
                                    PlayerIndicatorView(systemImageName: viewModel.moves[i]?.indicator ?? "", indicatorColor: viewModel.moves[i]?.indicator == "xmark" ? Color.red : Color.blue )
                                }
                                .onTapGesture {
                                    viewModel.processPlayerMoves(for: i)
                                }
                            }
                        }
                        Spacer()
                            Text(viewModel.player2Name)
                                .foregroundColor(Color.blue)
                        
                        .font(.title).bold()
                    }
                    .toolbar {
                        Button {
                            showingSettings = true
                        } label: {
                            Image(systemName: "person.2.badge.gearshape.fill")
                        }
                        Button("Reset") {
                            viewModel.resetGame()
                        }
                    }
                    .sheet(isPresented: $showingSettings) {
                        SettingsView(matches: Matches())
                    }
                    .disabled(viewModel.isGameboardDisabled)
                    .padding()
                    .alert(item: $viewModel.alertItem, content: { alertItem in
                        Alert(title: alertItem.title,
                              message: alertItem.message,
                              dismissButton: .default(alertItem.buttonTitle, action: { viewModel.resetGame() }))
                    })
                }
            }
        }
    }
}

enum Player {
    case playerOne, playerTwo
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .playerOne ? "xmark" : "circle"
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct GameSquareView: View {
    
    var proxy: GeometryProxy
    var body: some View {
        Circle()
            .stroke(lineWidth: 5)
//            .foregroundColor(.blue).opacity(0.1)
            .frame(width: proxy.size.width/3 - 15, height: proxy.size.height/3 - 95)
            .glow()
    }
}

struct PlayerIndicatorView: View {
    var systemImageName: String
    var indicatorColor: Color
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(indicatorColor)
            .glow()
    }
}

extension View {
    func glow() -> some View {
        self
            .foregroundColor(Color(hue: 0.9, saturation: 0.8, brightness: 1))
            .background {
                self
                    .foregroundColor(Color(hue: 0.9, saturation: 0.8, brightness: 1))
                    .blur(radius: 5)
                    .opacity(0.5)
            }
            .background {
                self
                    .foregroundColor(Color(hue: 0.9, saturation: 0.8, brightness: 1))
                    .blur(radius: 5)
            }
            .background {
                self
                    .foregroundColor(Color(hue: 0.9, saturation: 0.8, brightness: 1))
                    .blur(radius: 5)
            }
            .opacity(0.5)

    }
}

