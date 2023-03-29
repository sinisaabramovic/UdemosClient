//
//  SimpleSecretMessageViewModel.swift
//  UdemosClient
//
//  Created by Sinisa Abramovic on 28.03.2023..
//

import Foundation
import SwiftUI

class SimpleSecretMessageViewModel: ObservableObject {
    
    // MARK: - Public properties -
    
    @Published var messages: [SimpleSecretMessage] = []
    @Published var inputMessage: String = ""
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    // MARK: - Private properties -
    
    private let apiManager = SecureDataSender(
        baseURL: Routes.baseUrlRemote,
        encryptionService: EncryptionService(privateKeyFileName: "private_key")
    )
    
}

// MARK: - Extensions -

extension SimpleSecretMessageViewModel {
    
    func sendEncryptedMessage() async {
        do {
            let message = SimpleSecretMessage(message: inputMessage)
            let jsonData = try JSONEncoder().encode(message)
            
            DispatchQueue.main.async {
                self.messages.append(message)
            }
            
            let response = try await apiManager.sendEncryptedMessage(jsonData: jsonData, path: "simplesecret")
            
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

private extension SimpleSecretMessageViewModel {
    
    func parseSecretMessage(from data: Data?) -> Result<SimpleSecretMessage, Error> {
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
            let secretMessage = SimpleSecretMessage(message: message)
            return .success(secretMessage)
        } catch {
            return .failure(APIError.decodingError(error))
        }
    }
    
}
