//
//  iOS_Workshop_2024App.swift
//  iOS-Workshop-2024
//
//  Created by Brandon Wong on 2/19/24.
//

import SwiftUI

@main
struct iOS_Workshop_2024App: App {
    @StateObject var viewModel = PokemonViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .task {
                    do {
                        try await viewModel.load()
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
        }
    }
}
