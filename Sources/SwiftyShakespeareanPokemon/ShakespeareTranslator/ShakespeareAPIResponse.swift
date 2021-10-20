//
//  File.swift
//  
//
//  Created by Daven.Gomes on 17/10/2021.
//

import Foundation

struct ShakespeareAPIResponse: Decodable {

    struct Contents: Decodable {
        let translated: String
    }

    let contents: Contents
}
