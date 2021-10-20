//
//  File.swift
//  
//
//  Created by Daven.Gomes on 17/10/2021.
//

import Foundation

protocol PokeAPIClientProtocol {
    
    func getDescription(
        for pokemonName: String,
        completion: @escaping (Result<String, PokeShakespeareError>) -> Void)
    
    func getSprite(
        for pokemonName: String,
        completion: @escaping (Result<URL, PokeShakespeareError>) -> Void)
}

public final class PokeAPIClient: PokeAPIClientProtocol {
    
    private let decoder: Decoding
    private let urlSession: URLSessionProtocol
    private var endpointProvider: EndpointProviding
    
    init(decoder: Decoding,
         urlSession: URLSessionProtocol,
         endpointProvider: EndpointProviding) {
        
        self.decoder = decoder
        self.urlSession = urlSession
        self.endpointProvider = endpointProvider
    }
    
    public convenience init() {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        self.init(decoder: decoder,
                  urlSession: URLSession.shared,
                  endpointProvider: EndpointProvider())
    }
    
    public func getDescription(
        for pokemonName: String,
        completion: @escaping (Result<String, PokeShakespeareError>) -> Void) {
            
            guard let url = endpointProvider.pokeDescription(for: pokemonName) else {
                completion(.failure(.malformedURL))
                return
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            
            let dataTask = urlSession.dataTask(
                with: urlRequest) { data, urlResponse, error in
                    
                    if let error = error {
                        
                        completion(.failure(.pokeResponse(error)))
                        return
                    }
                    
                    guard let data = data else {
                        completion(.failure(.pokeDataNil))
                        return
                    }
                    
                    let speciesDescriptionResult = self.speciesDescription(from: data)
                    
                    completion(speciesDescriptionResult)
                }
            
            dataTask.resume()
        }
    
    public func getSprite(
        for pokemonName: String,
        completion: @escaping (Result<URL, PokeShakespeareError>) -> Void) {
            
            guard let url = endpointProvider.pokeSprite(for: pokemonName) else {
                completion(.failure(.malformedURL))
                return
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            
            let dataTask = urlSession.dataTask(
                with: urlRequest) { data, urlResponse, error in
                    
                    if let error = error {
                        
                        completion(.failure(.pokeResponse(error)))
                        return
                    }
                    
                    guard let data = data else {
                        completion(.failure(.pokeDataNil))
                        return
                    }
                    
                    let spriteResult = self.sprite(from: data)
                    
                    completion(spriteResult)
                }
            
            dataTask.resume()
        }
    
    // MARK: - Private
    
    private func speciesDescription(from data: Data) -> Result<String, PokeShakespeareError> {
        
        do {
            
            let pokemonSpeciesResponse = try decoder.decode(
                PokemonSpeciesResponse.self,
                from: data)
            
            guard let validFlavorText = pokemonSpeciesResponse.flavorTextEntries.first(where: { $0.language.name == "en" }) else {
                return .failure(.noEnglishFlavorTextFound)
            }
            
            return .success(validFlavorText.flavorText)
        } catch {
            return .failure(.decodingError(error))
        }
    }
    
    private func sprite(from data: Data) -> Result<URL, PokeShakespeareError> {
        
        do {
            
            let pokemonSpeciesResponse = try decoder.decode(
                PokemonSpriteResponse.self,
                from: data)
            
            return .success(pokemonSpeciesResponse.sprites.frontDefault)
            
        } catch {
            return .failure(.decodingError(error))
        }
    }
}
