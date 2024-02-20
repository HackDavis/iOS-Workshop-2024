//
//  ContentView.swift
//  iOS-Workshop-2024
//
//  Created by Brandon Wong on 2/19/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PokemonViewModel()
    
    var body: some View {
        NavigationStack {
            TabView {
                MyPokemonView(viewModel: viewModel)
                    .tabItem {
                        Label("My Pokemon", systemImage: "tray.and.arrow.down.fill")
                    }
                AllPokemonView(viewModel: viewModel)
                    .tabItem {
                        Label("All Pokemon", systemImage: "tray.and.arrow.up.fill")
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
