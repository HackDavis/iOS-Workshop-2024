//
//  MyPokemonView.swift
//  iOS-Workshop-2024
//
//  Created by Brandon Wong on 2/19/24.
//

import SwiftUI

struct MyPokemonView: View {
    @ObservedObject var viewModel = PokemonViewModel()
    
    @State private var showingAddPokemon = false
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.myPokemon) { pokemon in
                    VStack {
                        HStack {
                            let url = URL(string: pokemon.sprites.frontDefault!)
                            AsyncImage(url: url) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(minWidth: 0, maxWidth: 100)
                                } else {
                                    ProgressView()
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text(pokemon.name).bold()
                                Text("\(String(pokemon.height)) decimeters, \(String(pokemon.weight)) hectograms")
                            }
                            
                            Spacer()
                        }
                        .frame(height: 100)
                        
                        Divider()
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddPokemon) {
            AddPokemonView(viewModel: viewModel)
        }
        .navigationTitle("My Pokemon")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAddPokemon = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    MyPokemonView()
}
