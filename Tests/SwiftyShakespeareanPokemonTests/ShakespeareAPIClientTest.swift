    import XCTest
    @testable import SwiftyShakespeareanPokemon

    final class ShakespeareAPIClientTests: XCTestCase {

        private var subject: ShakespeareAPIClient!
        private var stubEncoder: StubEncoder! = StubEncoder()
        private var stubDecoder: StubDecoder! = StubDecoder()
        private var stubURLSession: StubURLSession! = StubURLSession()
        private var stubEndpointProvider: StubEndpointProvider = StubEndpointProvider()

        override func setUp() {
            super.setUp()

            subject = ShakespeareAPIClient(
                encoder: stubEncoder,
                decoder: stubDecoder,
                urlSession: stubURLSession,
                endpointProvider: stubEndpointProvider)
        }

        // MARK: - getDescription

        func test_translate_endpointProviderReturnsNil_returnsCorrectError() {

            stubEndpointProvider.shakespeareTranslationToReturn = nil
            var resultError: PokeShakespeareError?

            subject.translate("test input") { result in
                switch result {
                case .success: XCTFail()
                case .failure(let error):
                    resultError = error
                }
            }

            guard case .malformedURL = resultError else {
                return XCTFail("Unexpected error.")
            }
        }

        func test_translate_urlSessionCalledCorrectly() {

            stubEndpointProvider.shakespeareTranslationToReturn = URL(string: "testURL.com")!
            subject.translate("test input") { _ in }

            let urlRequest = stubURLSession.dataTaskCalledWith?.request
            XCTAssertEqual(urlRequest?.httpMethod, "POST")
            XCTAssertEqual(urlRequest?.allHTTPHeaderFields?["Content-Type"], "application/json")
            XCTAssertEqual(urlRequest?.allHTTPHeaderFields?["Accept"], "application/json")
            XCTAssertEqual(urlRequest?.url, URL(string: "testURL.com"))
        }

        func test_translate_encoderCalledCorrectly() {

            subject.translate("test input") { _ in }

            let payload = stubEncoder.encodeCalledWith as! ShakespeareAPIPayload

            XCTAssertEqual(payload.text, "test input")
        }

        func test_translate_encoderReturnsError_errorReturned() {

            stubEncoder.encodeToThrow = StubError.one
            var resultError: PokeShakespeareError?

            subject.translate("test input") { result in
                switch result {
                case .success: XCTFail()
                case .failure(let error):
                    resultError = error
                }
            }

            guard case .encodingError(let error) = resultError else {
                return XCTFail("Unexpected error.")
            }

            XCTAssertEqual(error as? StubError, .one)
        }

        func test_translate_urlSessionReturnsError_errorReturned() {

            stubEncoder.encodeToReturn = Data("stub data".utf8)
            var resultError: PokeShakespeareError?

            subject.translate("test input") { result in

                switch result {

                case .success:
                    XCTFail()
                case .failure(let error):
                    resultError = error
                }
            }

            stubURLSession.dataTaskCalledWith?.completionHandler(nil, nil, StubError.one)

            guard case .shakespeareResponse(let error) = resultError else {
                return XCTFail()
            }

            XCTAssertEqual(error as? StubError, .one)
        }

        func test_translate_urlSessionReturnsNilData_errorReturned() {

            stubEncoder.encodeToReturn = Data("stub data".utf8)
            var resultError: PokeShakespeareError?

            subject.translate("test input") { result in

                switch result {
                case .success:
                    XCTFail()
                case .failure(let error):
                    resultError = error
                }
            }

            stubURLSession.dataTaskCalledWith?.completionHandler(nil, nil, nil)

            guard case .shakespeareDataNil = resultError else {
                return XCTFail()
            }
        }

        func test_translate_decoderCalledCorrectly() {

            let stubData = Data("test".utf8)
            stubDecoder.decodeToThrow = StubError.one
            var resultError: PokeShakespeareError?

            subject.translate("test input") { result in

                switch result {
                case .success:
                    XCTFail()
                case .failure(let error):
                    resultError = error
                }
            }

            stubURLSession.dataTaskCalledWith?.completionHandler(stubData, nil, nil)

            XCTAssert(stubDecoder.decodeCalledWith?.type is ShakespeareAPIResponse.Type)
            XCTAssertEqual(stubDecoder.decodeCalledWith?.data, stubData)

            guard case .decodingError(let error) = resultError else {
                return XCTFail()
            }

            XCTAssertEqual(error as? StubError, .one)
        }

        func test_translate_returnsCorrectTranslation() {

            let stubData = Data("test".utf8)
            let apiResponse = ShakespeareAPIResponse(contents: .init(translated: "test translation"))
            var resultTranslation: String?
            stubDecoder.decodeToReturn = apiResponse

            subject.translate("stub input") { result in

                switch result {
                case .success(let translation):
                    resultTranslation = translation
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }

            stubURLSession.dataTaskCalledWith?.completionHandler(stubData, nil, nil)

            XCTAssertEqual(resultTranslation, "test translation")
        }

        
    }
