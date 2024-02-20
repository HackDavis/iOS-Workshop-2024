//
//  ContentView.swift
//  iOS-Workshop-2024
//
//  Created by Brandon Wong on 2/19/24.
//

import SwiftUI

struct PokemonData: Codable {
    let count: Int
    let results: [Pokemon]
}

struct Pokemon: Identifiable, Codable {
    let id = UUID()
    let name: String
}

enum NetworkError: Error {
    case error
}

class PokemonViewModel: ObservableObject {
    @Published var pokemon = [Pokemon]()
    
    func fetchData(url: String) async {
        do {
            guard let url = URL(string: url) else {
                throw NetworkError.error
            }
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.error
            }
            guard let decodedResponse = try? JSONDecoder().decode(PokemonData.self, from: data) else {
                throw NetworkError.error
            }
            
            pokemon = decodedResponse.results
        } catch {
            print("An error occured downloading the data")
        }
    }
}

struct ContentView: View {
    @StateObject var viewModel = PokemonViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.pokemon) { pokemon in
                Text(pokemon.name)
            }
        }
        .onAppear{
            Task {
                await viewModel.fetchData(url: "https://pokeapi.co/api/v2/pokemon")
            }
        }
    }
}

#Preview {
    ContentView()
}
