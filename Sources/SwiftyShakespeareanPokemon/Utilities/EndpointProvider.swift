//
//  File.swift
//  
//
//  Created by Daven Gomes on 20/10/2021.
//

import Foundation

protocol EndpointProviding {
    func pokeDescription(for name: String) -> URL?
    func pokeSprite(for name: String) -> URL?
    func shakespeareTranslation() -> URL?
}

final class EndpointProvider: EndpointProviding {
    
    func pokeDescription(for name: String) -> URL? {
        URL(string: "https://pokeapi.co/api/v2/pokemon-species/\(name)")
    }
    
    func pokeSprite(for name: String) -> URL? {
        URL(string: "https://pokeapi.co/api/v2/pokemon/\(name)")
    }

    func shakespeareTranslation() -> URL? {
        URL(string: "https://api.funtranslations.com/translate/shakespeare")
    }
}
