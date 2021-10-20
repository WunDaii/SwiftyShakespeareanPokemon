//
//  File.swift
//  
//
//  Created by Daven.Gomes on 19/10/2021.
//

import Foundation
@testable import SwiftyShakespeareanPokemon

final class StubEndpointProvider: EndpointProviding {

    var pokeDescriptionCalledWith: String?
    var pokeDescriptionToReturn: URL? = URL(string: "testPokeDesc.com")!
    func pokeDescription(for name: String) -> URL? {
        pokeDescriptionCalledWith = name
        return pokeDescriptionToReturn
    }

    var pokeSpriteCalledWith: String?
    var pokeSpriteToReturn: URL? = URL(string: "testPokeSprite.com")!
    func pokeSprite(for name: String) -> URL? {
        pokeDescriptionCalledWith = name
        return pokeSpriteToReturn
    }

    var shakespeareTranslationToReturn: URL? = URL(string: "testShakesTranslate.com")!
    func shakespeareTranslation() -> URL? {
        shakespeareTranslationToReturn
    }
}
