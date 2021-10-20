//
//  File.swift
//  
//
//  Created by Daven.Gomes on 19/10/2021.
//

import Foundation
@testable import SwiftyShakespeareanPokemon

final class StubURLSessionDataTask: URLSessionDataTask {

    private(set) var resumeWasCalled = false

    override init() { }

    override func resume() {
        resumeWasCalled = true
    }
}
