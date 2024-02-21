//
//  AddPokemonView.swift
//  iOS-Workshop-2024
//
//  Created by Brandon Wong on 2/20/24.
//

import SwiftUI

struct AddPokemonView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = PokemonViewModel()
    
    @State private var name = ""
    
    var body: some View {
        VStack {
            TextField("Pokemon Name", text: $name)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 300)
            
            Button("Search") {
                Task {
                    await viewModel.fetchPokemon(name: name)
                    do {
                        try await viewModel.save(pokemon: viewModel.myPokemon)
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
                
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    AddPokemonView()
}
