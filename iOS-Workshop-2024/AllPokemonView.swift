//
//  AllPokemonView.swift
//  iOS-Workshop-2024
//
//  Created by Brandon Wong on 2/20/24.
//

import SwiftUI

struct AllPokemonView: View {
    @ObservedObject var viewModel = PokemonViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.allPokemon) { pokemon in
                Text(pokemon.name)
            }
        }
        .onAppear{
            Task {
                await viewModel.fetchAll()
            }
        }
    }
}

#Preview {
    AllPokemonView()
}
