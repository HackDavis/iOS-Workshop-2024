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
    @Published var allPokemon = [CompressedPokemon]()
    @Published var myPokemon = [Pokemon]()
    
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
    
    func fetchAll() async {
        guard let pokemonResults: PokemonData = await callApi(url: "https://pokeapi.co/api/v2/pokemon") else { return }
        allPokemon = pokemonResults.results
    }
    
    func fetchPokemon(name: String) async {
        guard let pokemonResults: Pokemon = await callApi(url: "https://pokeapi.co/api/v2/pokemon/\(name.lowercased())") else { return }
        myPokemon.append(pokemonResults)
    }
}
