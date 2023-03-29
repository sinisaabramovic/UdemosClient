//
//  SimpleSecretMessage.swift
//  UdemosClient
//
//  Created by Sinisa Abramovic on 28.03.2023..
//

import Foundation

struct SimpleSecretMessage: Codable {
    
    // MARK: - Public properties -
    
    let message: String
    
    // MARK: - Lifecycle -
    
    init(message: String) {
        self.message = message
    }
}

// MARK: - Extensions -

extension SimpleSecretMessage: Hashable {
    
    static func == (lhs: SimpleSecretMessage, rhs: SimpleSecretMessage) -> Bool {
        return lhs.message == rhs.message
    }
    
}
