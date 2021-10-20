//
//  File.swift
//  
//
//  Created by Daven.Gomes on 18/10/2021.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Foundation.URLSessionDataTask

    func dataTask(with request: URLRequest) -> Foundation.URLSessionDataTask
}
