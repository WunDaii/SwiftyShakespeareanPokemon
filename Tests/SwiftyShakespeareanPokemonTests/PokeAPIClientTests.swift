//
//  File.swift
//  
//
//  Created by Daven.Gomes on 18/10/2021.
//

import XCTest
@testable import SwiftyShakespeareanPokemon

final class PokeAPIClientTests: XCTestCase {

    private var subject: PokeAPIClient!
    private var stubDecoder: StubDecoder = StubDecoder()
    private var stubURLSession: StubURLSession = StubURLSession()
    private var stubEndpointProvider: StubEndpointProvider = StubEndpointProvider()

    override func setUp() {
        super.setUp()

        subject = PokeAPIClient(
            decoder: stubDecoder,
            urlSession: stubURLSession,
            endpointProvider: stubEndpointProvider)
    }

    // MARK: - getDescription

    func test_getDescription_endpointProviderReturnsNil_returnsCorrectError() {

        stubEndpointProvider.pokeDescriptionToReturn = nil
        var resultError: PokeShakespeareError?

        subject.getDescription(for: "stub_name") { result in
            switch result {
            case .success: XCTFail()
            case .failure(let error):
                resultError = error
            }
        }

        XCTAssertEqual(stubEndpointProvider.pokeDescriptionCalledWith, "stub_name")

        guard case .malformedURL = resultError else {
            return XCTFail("Unexpected error.")
        }
    }

    func test_getDescription_urlSessionCalledCorrectly() {

        stubEndpointProvider.pokeDescriptionToReturn = URL(string: "testURL.com")!
        subject.getDescription(for: "stub_name") { _ in }

        let urlRequest = stubURLSession.dataTaskCalledWith?.request
        XCTAssertEqual(urlRequest?.httpMethod, "GET")
        XCTAssertEqual(urlRequest?.url, URL(string: "testURL.com"))
    }

    func test_getDescription_urlSessionReturnsError_errorReturned() {

        enum TestError: Error { case one }
        var resultError: PokeShakespeareError?

        subject.getDescription(for: "stub_name") { result in

            switch result {

            case .success:
                XCTFail()
            case .failure(let error):
                resultError = error
            }
        }

        stubURLSession.dataTaskCalledWith?.completionHandler(nil, nil, TestError.one)

        guard case .pokeResponse(let error) = resultError else {
            return XCTFail()
        }

        XCTAssertEqual(error as? TestError, .one)
    }

    func test_getDescription_urlSessionReturnsNilData_errorReturned() {

        var resultError: PokeShakespeareError?

        subject.getDescription(for: "stub_name") { result in

            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                resultError = error
            }
        }

        stubURLSession.dataTaskCalledWith?.completionHandler(nil, nil, nil)

        guard case .pokeDataNil = resultError else {
            return XCTFail()
        }
    }

    func test_getDescription_decoderCalledCorrectly() {

        let stubData = Data("test".utf8)
        stubDecoder.decodeToThrow = StubError.one
        var resultError: PokeShakespeareError?

        subject.getDescription(for: "stub_name") { result in

            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                resultError = error
            }
        }


        stubURLSession.dataTaskCalledWith?.completionHandler(stubData, nil, nil)

        XCTAssert(stubDecoder.decodeCalledWith?.type is PokemonSpeciesResponse.Type)
        XCTAssertEqual(stubDecoder.decodeCalledWith?.data, stubData)

        guard case .decodingError(let error) = resultError else {
            return XCTFail()
        }

        XCTAssertEqual(error as? StubError, .one)
    }

    func test_getDescription_flavorTextEntriesNoEn_returnsError() {

        let stubData = Data("test".utf8)
        var resultError: PokeShakespeareError?
        let response = PokemonSpeciesResponse(flavorTextEntries: [.init(flavorText: "test", language: PokemonSpeciesResponse.FlavorTextEntry.Language.init(name: "fr"))])
        stubDecoder.decodeToReturn = response

        subject.getDescription(for: "stub_name") { result in

            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                resultError = error
            }
        }

        stubURLSession.dataTaskCalledWith?.completionHandler(stubData, nil, nil)

        guard case .noEnglishFlavorTextFound = resultError else {
            return XCTFail()
        }
    }

    func test_getDescription_returnsCorrectFlavorTextEntry() {

        let stubData = Data("test".utf8)
        var resultDescription: String?
        let firstFlavorText = PokemonSpeciesResponse.FlavorTextEntry(flavorText: "test1",
                                                                     language: PokemonSpeciesResponse.FlavorTextEntry.Language.init(name: "en"))
        let secondFlavorText = PokemonSpeciesResponse.FlavorTextEntry(flavorText: "test2",
                                                                      language: PokemonSpeciesResponse.FlavorTextEntry.Language.init(name: "en"))
        let response = PokemonSpeciesResponse(flavorTextEntries: [firstFlavorText,
                                                                  secondFlavorText])
        stubDecoder.decodeToReturn = response

        subject.getDescription(for: "stub_name") { result in

            switch result {
            case .success(let description):
                resultDescription = description
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }

        stubURLSession.dataTaskCalledWith?.completionHandler(stubData, nil, nil)

        XCTAssertEqual(resultDescription, "test1")
    }

    // MARK: - getSprite

    func test_getSprite_endpointProviderReturnsNil_returnsCorrectError() {

        stubEndpointProvider.pokeSpriteToReturn = nil
        var resultError: PokeShakespeareError?

        subject.getSprite(for: "stub_name") { result in
            switch result {
            case .success: XCTFail()
            case .failure(let error):
                resultError = error
            }
        }

        XCTAssertEqual(stubEndpointProvider.pokeDescriptionCalledWith, "stub_name")

        guard case .malformedURL = resultError else {
            return XCTFail("Unexpected error.")
        }
    }

    func test_getSprite_urlSessionCalledCorrectly() {

        stubEndpointProvider.pokeSpriteToReturn = URL(string: "testURL.com")!
        subject.getSprite(for: "stub_name") { _ in }

        let urlRequest = stubURLSession.dataTaskCalledWith?.request
        XCTAssertEqual(urlRequest?.httpMethod, "GET")
        XCTAssertEqual(urlRequest?.url, URL(string: "testURL.com"))
    }

    func test_getSprite_urlSessionReturnsError_errorReturned() {

        enum TestError: Error { case one }
        var resultError: PokeShakespeareError?

        subject.getSprite(for: "stub_name") { result in

            switch result {

            case .success:
                XCTFail()
            case .failure(let error):
                resultError = error
            }
        }

        stubURLSession.dataTaskCalledWith?.completionHandler(nil, nil, TestError.one)

        guard case .pokeResponse(let error) = resultError else {
            return XCTFail()
        }

        XCTAssertEqual(error as? TestError, .one)
    }

    func test_getSprite_urlSessionReturnsNilData_errorReturned() {

        var resultError: PokeShakespeareError?

        subject.getSprite(for: "stub_name") { result in

            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                resultError = error
            }
        }

        stubURLSession.dataTaskCalledWith?.completionHandler(nil, nil, nil)

        guard case .pokeDataNil = resultError else {
            return XCTFail()
        }
    }

    func test_getSprite_decoderCalledCorrectly() {

        let stubData = Data("test".utf8)
        stubDecoder.decodeToThrow = StubError.one
        var resultError: PokeShakespeareError?

        subject.getSprite(for: "stub_name") { result in

            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                resultError = error
            }
        }


        stubURLSession.dataTaskCalledWith?.completionHandler(stubData, nil, nil)

        XCTAssert(stubDecoder.decodeCalledWith?.type is PokemonSpriteResponse.Type)
        XCTAssertEqual(stubDecoder.decodeCalledWith?.data, stubData)

        guard case .decodingError(let error) = resultError else {
            return XCTFail()
        }

        XCTAssertEqual(error as? StubError, .one)
    }

    func test_getSprite_returnsCorrectFlavorTextEntry() {

        let stubData = Data("test".utf8)
        var resultURL: URL?
        stubDecoder.decodeToReturn = PokemonSpriteResponse(sprites: .init(frontDefault: URL(string: "test.com")!))

        subject.getSprite(for: "stub_name") { result in

            switch result {
            case .success(let url):
                resultURL = url
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }

        stubURLSession.dataTaskCalledWith?.completionHandler(stubData, nil, nil)

        XCTAssertEqual(resultURL, URL(string: "test.com")!)
    }
}
