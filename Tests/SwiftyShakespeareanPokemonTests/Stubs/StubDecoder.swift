//
//  File.swift
//  
//
//  Created by Daven.Gomes on 19/10/2021.
//

import Foundation
@testable import SwiftyShakespeareanPokemon

final class StubDecoder: Decoding {

    private(set) var decodeCalledWith: (type: Decodable.Type, data: Data)?
    var decodeToThrow: Error?
    var decodeToReturn: Decodable!

    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {

        decodeCalledWith = (type, data)

        if let decodeToThrow = decodeToThrow {
            throw decodeToThrow
        }

        // swiftlint:disable force_cast
        return decodeToReturn as! T
    }
}
