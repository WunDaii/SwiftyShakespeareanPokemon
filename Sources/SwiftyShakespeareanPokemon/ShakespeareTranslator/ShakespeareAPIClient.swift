//
//  File.swift
//  
//
//  Created by Daven.Gomes on 17/10/2021.
//

import Foundation

protocol ShakespeareAPIClientProtocol {
    
    func translate(
        _ text: String,
        completion: @escaping (Result<String, PokeShakespeareError>) -> Void)
}

public final class ShakespeareAPIClient: ShakespeareAPIClientProtocol {
    
    private let encoder: Encoding
    private let decoder: Decoding
    private let urlSession: URLSessionProtocol
    private let endpointProvider: EndpointProviding
    
    init(encoder: Encoding,
         decoder: Decoding,
         urlSession: URLSessionProtocol,
         endpointProvider: EndpointProviding) {
        
        self.encoder = encoder
        self.decoder = decoder
        self.urlSession = urlSession
        self.endpointProvider = endpointProvider
    }
    
    public convenience init() {
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        self.init(encoder: encoder,
                  decoder: decoder,
                  urlSession: URLSession.shared,
                  endpointProvider: EndpointProvider())
    }
    
    public func translate(
        _ text: String,
        completion: @escaping (Result<String, PokeShakespeareError>) -> Void) {

        guard let url = endpointProvider.shakespeareTranslation() else {
            completion(.failure(.malformedURL))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")


        do {

            urlRequest.httpBody = try encoder.encode(ShakespeareAPIPayload(text: text))

        } catch {
            completion(.failure(.encodingError(error)))
            return
        }

        let dataTask = urlSession.dataTask(
            with: urlRequest) { data, urlResponse, error in

            if let error = error {

                completion(.failure(.shakespeareResponse(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.shakespeareDataNil))
                return
            }

            do {

                let shakespeareTranslation = try self.shakespeareTranslation(from: data)
                return completion(.success(shakespeareTranslation))

            } catch {
                completion(.failure(.decodingError(error)))
                return
            }
        }

        dataTask.resume()
    }
    
    private func shakespeareTranslation(from data: Data) throws -> String {
        
        do {
            
            let shakespeareAPIResponse = try decoder.decode(
                ShakespeareAPIResponse.self,
                from: data)
            
            return shakespeareAPIResponse.contents.translated
            
        } catch {
            throw error
        }
    }
}
