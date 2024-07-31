//
//  PokemonInfoViewModel.swift
//  PokedexApplication
//
//  Created by Michael Taylor on 7/31/24.
//


import Foundation

import SwiftUI

final class PokemonInfoViewModel: ObservableObject {
    @Published var pokemon: Pokemon?
    @Published var isLoading: Bool = false
    
    // Custom Error Types for Network Call
    enum pokeError: Error {
        case invalidURL
        case invalidResponse
        case invalidData
    }
    
    // Functions
    func searchPokemon(named pokemonName: String) async{
        isLoading = true
        do {
            try await fetchPokemonData(pokemonName: pokemonName)
        } catch pokeError.invalidURL {
            print("Invalid URL")
        } catch pokeError.invalidResponse {
            print("Invalid response")
        } catch pokeError.invalidData {
            print("Invalid data")
        } catch {
            print("Unexpected error")
        }
        isLoading = false
    }
    
    func fetchPokemonData(pokemonName: String) async throws {
        let api =  "https://pokeapi.co/api/v2/pokemon/\(pokemonName)"
        
        // turning the string form of url to URL dataType
        guard let url = URL(string: api) else {
            throw pokeError.invalidURL
        }
        
        // Actually making the API call
        let (data, response) = try await URLSession.shared.data(from: url)
        // going to need to address both data and response
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw pokeError.invalidResponse
        }

        // data
        do {
            let decoder = JSONDecoder()
            
            //decoder.keyDecodingStrategy = .convertFromSnakeCase  // -> the pokemon API is snakeCase, but I wanted to Coding Keys instead
            self.pokemon = try decoder.decode(Pokemon.self, from: data)
        } catch {
            throw pokeError.invalidData
        }
    }
    
    // Getter Functions
    func getName() -> String{
        return pokemon?.name.capitalized ?? "Pokemon's Name"
    }
    
    func getId() -> Int{
        return pokemon?.id ?? 0
    }
    
    func getFrontDefault() -> URL? {
        guard let frontDefault = pokemon?.sprites.other.officialArtwork.frontDefault else {
            return nil
        }
        return URL(string: frontDefault)
    }
    
    func getFrontShiny() -> URL? {
        guard let frontShiny = pokemon?.sprites.other.officialArtwork.frontShiny else {
            return nil
        }
        return URL(string: frontShiny)
    }
    
}

