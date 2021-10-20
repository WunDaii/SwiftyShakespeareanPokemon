//
//  File.swift
//  
//
//  Created by Daven.Gomes on 18/10/2021.
//

import Foundation

protocol Encoding {
    func encode<T>(_ value: T) throws -> Data where T: Encodable
}
