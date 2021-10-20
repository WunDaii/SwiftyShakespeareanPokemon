//
//  File.swift
//  
//
//  Created by Daven.Gomes on 17/10/2021.
//

import Foundation

struct PokemonSpriteResponse: Decodable {

    let sprites: Sprites

    struct Sprites: Decodable {

        let frontDefault: URL
    }
}
