//
//  File.swift
//  
//
//  Created by Daven.Gomes on 19/10/2021.
//

import Foundation
@testable import SwiftyShakespeareanPokemon

final class StubURLSession: URLSessionProtocol {
    //swiftlint:disable:next
    private(set) var dataTaskCalledWith: (request: URLRequest, completionHandler: ((Data?, URLResponse?, Error?) -> Void))?
    var dataTaskToReturn = StubURLSessionDataTask()

    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Foundation.URLSessionDataTask {

        dataTaskCalledWith = (request, completionHandler)
        return dataTaskToReturn
    }

    func dataTask(with request: URLRequest) -> Foundation.URLSessionDataTask {
        return dataTask(with: request, completionHandler: { _, _, _ in })
    }
}
