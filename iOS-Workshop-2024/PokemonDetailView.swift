//
//  PokemonDetailView.swift
//  iOS-Workshop-2024
//
//  Created by Brandon Wong on 2/20/24.
//

import SwiftUI

struct PokemonDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    var pokemon: Pokemon
    
    var body: some View {
        List {
            ForEach(pokemon.moves) { move in
                Text(move.move.name)
            }
        }
        .navigationTitle("\(pokemon.name) Moves")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                }
            }
        }
    }
}
