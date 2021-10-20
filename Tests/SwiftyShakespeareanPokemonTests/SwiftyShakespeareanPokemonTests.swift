//
//  File.swift
//  
//
//  Created by Daven.Gomes on 20/10/2021.
//

import XCTest
@testable import SwiftyShakespeareanPokemon

final class SwiftyShakespeareanPokemonTests: XCTestCase {

    func test_makePokemonDetailView_returnsBlankDetailViewController() {

        let viewController = SwiftyShakespeareanPokemon.makePokemonDetailView()

        viewController.loadViewIfNeeded()

        XCTAssertEqual(viewController.titleLabel.text, "Loading name...")
        XCTAssertEqual(viewController.detailLabel.text, "Loading description...")
        XCTAssertNil(viewController.imageView.image)
    }
}
