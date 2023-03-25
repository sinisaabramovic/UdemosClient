//
//  SecretMessageViewModel.swift
//  UdemosClient
//
//  Created by Sinisa Abramovic on 22.03.2023..
//

import Foundation
import SwiftUI

class SecretMessageViewModel: ObservableObject {
    
    // MARK: - Public properties -
    
    @Published var messages: [SecretMessage] = []
    @Published var inputMessage: String = ""
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    // MARK: - Private properties -
    
    private let apiManager = SecureDataSender(
        baseURL: Routes.baseUrl,
        encryptionService: EncryptionService(privateKeyFileName: "private_key")
    )
    
}

// MARK: - Extensions -

extension SecretMessageViewModel {
    
    func sendEncryptedMessage() async {
        do {
            let message = SecretMessage(message: inputMessage, sentByUser: true)
            let jsonData = try JSONEncoder().encode(message)
            
            DispatchQueue.main.async {
                self.messages.append(message)
            }
            
            let response = try await apiManager.sendEncryptedMessage(jsonData: jsonData)
            
            let data = response.data(using: .utf8)!
            let fetchedSecretResult = parseSecretMessage(from: data)
            
            DispatchQueue.main.async {
                switch fetchedSecretResult {
                case .success(let secretMessage):
                    self.messages.append(secretMessage)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
        }
    }
    
}

private extension SecretMessageViewModel {
    
    func parseSecretMessage(from data: Data?) -> Result<SecretMessage, Error> {
        guard let data = data else {
            return .failure(APIError.decodingError(NSError(
                domain: "Error: decodingError for Data!",
                code: -1,
                userInfo: nil
            )))
        }
        
        do {
            guard
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            else {
                return .failure(APIError.customError("Error: JSONSerialization Failed!"))
            }
            
            let message = json["message"] as! String
            let createdAt = BaseDateFormatter.dateFormatterForSecretServer.date(
                from: json["createdAt"] as? String ?? "2001-01-01 00:00:00"
            )
            let id = UUID(uuidString: json["id"] as? String ?? "") ?? UUID()
            let secretMessage = SecretMessage(
                message: message,
                createdAt: createdAt ?? Date(),
                id: id,
                sentByUser: false
            )
            return .success(secretMessage)
        } catch {
            return .failure(APIError.decodingError(error))
        }
    }
    
}
