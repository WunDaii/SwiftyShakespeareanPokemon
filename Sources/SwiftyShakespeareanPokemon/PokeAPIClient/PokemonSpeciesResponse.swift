//
//  File.swift
//  
//
//  Created by Daven.Gomes on 17/10/2021.
//

import Foundation

struct PokemonSpeciesResponse: Decodable {

    let flavorTextEntries: [FlavorTextEntry]

    struct FlavorTextEntry: Decodable {

        let flavorText: String
        let language: Language

        struct Language: Decodable {

            let name: String
        }
    }
}
