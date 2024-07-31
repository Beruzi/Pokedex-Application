//
//  PokemonInfoModel.swift
//  PokedexApplication
//
//  Created by Michael Taylor on 7/31/24.
//

import Foundation



struct Pokemon: Codable {
    let name: String
    let weight: Int
    let id: Int
    let sprites: Sprites
    let types: [PokemonType]
}

// Decoding the Sprites
struct Sprites: Codable {
    struct Other: Codable {
        struct OfficialArtwork: Codable {
            let frontDefault: String?
            let frontShiny: String?

            enum CodingKeys: String, CodingKey {
                case frontDefault = "front_default"
                case frontShiny = "front_shiny"
            }
        }
        let officialArtwork: OfficialArtwork
        enum CodingKeys: String, CodingKey {
            case officialArtwork = "official-artwork"
        }
    }
    let other: Other
}





// Decoding the types -> nested again
struct PokemonType: Codable {
    struct type: Codable {
        let name: String
    }
    let type: type
    
}
