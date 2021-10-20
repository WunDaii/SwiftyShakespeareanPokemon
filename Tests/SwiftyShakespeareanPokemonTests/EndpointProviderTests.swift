//
//  File.swift
//  
//
//  Created by Daven.Gomes on 20/10/2021.
//

import XCTest
@testable import SwiftyShakespeareanPokemon

final class EndpointProviderTests: XCTestCase {

    private let subject = EndpointProvider()

    func test_pokeDescription_returnsCorrectURL() {

        let url = subject.pokeDescription(for: "testPokemon")

        XCTAssertEqual(url,
                       URL(string: "https://pokeapi.co/api/v2/pokemon-species/testPokemon"))
    }

    func test_pokeSprite_returnsCorrectURL() {

        let url = subject.pokeSprite(for: "testPokemon")

        XCTAssertEqual(url,
                       URL(string: "https://pokeapi.co/api/v2/pokemon/testPokemon"))
    }

    func test_shakespeareTranslation_returnsCorrectURL() {

        let url = subject.shakespeareTranslation()

        XCTAssertEqual(url,
                       URL(string: "https://api.funtranslations.com/translate/shakespeare"))
    }
}
