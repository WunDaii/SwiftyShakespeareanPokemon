//
//  File.swift
//  
//
//  Created by Daven.Gomes on 19/10/2021.
//

import Foundation
@testable import SwiftyShakespeareanPokemon

final class StubEncoder: Encoding {

    private(set) var encodeCalledWith: Encodable?
    var encodeToReturn = "{ \"test\": \"json\" }".data(using: .utf8)!
    var encodeToThrow: Error?

    func encode<T>(_ value: T) throws -> Data where T: Encodable {

        encodeCalledWith = value

        if let error = encodeToThrow {
            throw error
        }

        return encodeToReturn
    }
}
