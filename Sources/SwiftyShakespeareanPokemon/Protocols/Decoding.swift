//
//  File.swift
//  
//
//  Created by Daven.Gomes on 18/10/2021.
//

import Foundation

protocol Decoding {

    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}
