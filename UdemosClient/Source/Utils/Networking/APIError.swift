//
//  APIError.swift
//  UdemosClient
//
//  Created by Sinisa Abramovic on 25.03.2023..
//

import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case encryptionError(Error)
    case decryptionError(Error)
    case customError(String)
}
