//
//  APIManager.swift
//  UdemosClient
//
//  Created by Sinisa Abramovic on 21.03.2023..
//

import Foundation
import Alamofire
import CryptoSwift

final class SecureDataSender {
    
    // MARK: - Private properties -
    
    private let baseURL: URL?
    private let encryptionService: EncryptionService
    
    // MARK: - Lifecycle -
    
    init(baseURL: URL?, encryptionService: EncryptionService) {
        self.baseURL = baseURL
        self.encryptionService = encryptionService
    }
    
    func getBaseURL() -> URL? {
        return baseURL
    }
}

// MARK: - Extensions -

extension SecureDataSender {
    
    func sendEncryptedMessage(jsonData: Data) async throws -> String {
        guard let baseURL else {
            throw APIError.networkError(NSError(
                domain: "InvalidBaseURL",
                code: -1,
                userInfo: nil
            ))
        }
        let requestURL = baseURL.appendingPathComponent("secret")
        
        let (encryptedData, key, iv) = try encryptionService.encrypt(data: jsonData)
        let base64String = encryptedData.base64EncodedString()
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpBody = Data(base64String.utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard
            let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
        else {
            throw APIError.networkError(NSError(
                domain: "InvalidStatusCode",
                code: (response as? HTTPURLResponse)?.statusCode ?? -1,
                userInfo: nil
            ))
        }
        
        if let base64ResponseString = String(data: data, encoding: .utf8),
           let decodedData = Data(base64Encoded: base64ResponseString) {
            let decryptedData = try encryptionService.decrypt(data: decodedData, key: key, iv: iv)
            let result = String(decoding: decryptedData, as: UTF8.self)
            return result
        } else {
            throw APIError.decodingError(NSError(domain: "InvalidBase64", code: -1, userInfo: nil))
        }
    }
}

