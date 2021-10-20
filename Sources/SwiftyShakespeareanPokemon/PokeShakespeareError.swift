//
//  File.swift
//  
//
//  Created by Daven.Gomes on 17/10/2021.
//

import Foundation

public enum PokeShakespeareError: Error {

    case malformedURL
    case encodingError(Error)
    case decodingError(Error)
    case pokeResponse(Error)
    case shakespeareResponse(Error)
    case shakespeareDataNil
    case pokeDataNil
    case noEnglishFlavorTextFound
    case couldNotCreateImageFromData
    case couldNotGetImageDataFromURL
}

extension PokeShakespeareError: LocalizedError {
    
    public var errorDescription: String? {
        
        switch self {

        case .malformedURL:
            return "Malformed URL."
        case .encodingError(let error):
            return "There was an issue encoding the object: \(error.localizedDescription)."
        case .decodingError(let error):
            return "There was an issue decoding the response: \(error.localizedDescription)."
        case .pokeResponse(let error):
            return "There was an error with parsing the Poke API response: \(error.localizedDescription)."
        case .shakespeareResponse(let error):
            return "There was an error with parsing the shakespeare API response: \(error.localizedDescription)."
        case .pokeDataNil:
            return "The data from the shakespeare sprite endpoint was nil."
        case .shakespeareDataNil:
            return "The data from the shakespeare API was nil."
        case .noEnglishFlavorTextFound:
            return "No English language found in the flavor text entries."
        case .couldNotCreateImageFromData:
            return "Could not create an image from the provided data."
        case .couldNotGetImageDataFromURL:
            return "Could not get image data from the provided sprite URL."
        }
    }
}
