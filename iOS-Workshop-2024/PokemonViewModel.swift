//
//  PokemonViewModel.swift
//  iOS-Workshop-2024
//
//  Created by Brandon Wong on 2/19/24.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case badResponse
    case badStatus
    case decodingError
    
    var errorMessage: String {
        switch self {
        case .invalidUrl:
            return "Error: Invalid URL"
        case .badResponse:
            return "Error: Bad response from server"
        case .badStatus:
            return "Error: Status code outside 200 range"
        case .decodingError:
            return "Error: Failed to decode JSON response"
        }
    }
}

class PokemonViewModel: ObservableObject {
    @Published var myPokemon = [Pokemon]()
    
// MARK: - API Call
    func callApi<T: Codable>(url: String) async -> T? {
        do {
            guard let url = URL(string: url) else {
                throw NetworkError.invalidUrl
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.badResponse
            }
            
            guard response.statusCode >= 200 && response.statusCode < 300 else {
                throw NetworkError.badStatus
            }
            
            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                throw NetworkError.decodingError
            }
            
            return decodedResponse
        } catch let error as NetworkError {
            print(error.errorMessage)
        } catch {
            print("Unknown Error")
        }
        
        return nil
    }
    
    func fetchPokemon(name: String) async {
        guard let pokemonResults: Pokemon = await callApi(url: "https://pokeapi.co/api/v2/pokemon/\(name.lowercased())") else { return }
        myPokemon.append(pokemonResults)
    }
    
// MARK: - Storage
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("pokemon.data")
    }


    func load() async throws {
        let task = Task<[Pokemon], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let pokemon = try JSONDecoder().decode([Pokemon].self, from: data)
            return pokemon
        }
        let pokemon = try await task.value
        self.myPokemon = pokemon
    }


    func save(pokemon: [Pokemon]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(pokemon)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
}
