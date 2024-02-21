//
//  ContentView.swift
//  iOS-Workshop-2024
//
//  Created by Brandon Wong on 2/19/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = PokemonViewModel()
    
    @State private var showingAddPokemon = false
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.myPokemon) { pokemon in
                    VStack {
                        HStack {
                            let url = URL(string: pokemon.sprites.frontDefault ?? "")
                            AsyncImage(url: url) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } else {
                                    Image(systemName: "photo")
                                }
                            }
                            .frame(width: 75, height: 75)
                            
                            VStack(alignment: .leading) {
                                Text(pokemon.name).font(.headline)
                                Text("Height: \(String(pokemon.height)) decimeters").font(.system(size: 12))
                                Text("Weight: \(String(pokemon.weight)) hectograms").font(.system(size: 12))
                            }
                            
                            Spacer()
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
}

#Preview {
    ContentView()
}
