//
//  SecretMessage.swift
//  UdemosClient
//
//  Created by Sinisa Abramovic on 22.03.2023..
//

import Foundation

struct SecretMessage: Codable {
    
    // MARK: - Public properties -
    
    let message: String
    let createdAt: Date
    let id: UUID
    let sentByUser: Bool
    
    // MARK: - Lifecycle -
    
    init(message: String) {
        self.message = message
        self.createdAt = Date()
        self.id = UUID()
        self.sentByUser = false
    }
    
    init(message: String, sentByUser: Bool) {
        self.message = message
        self.createdAt = Date()
        self.id = UUID()
        self.sentByUser = sentByUser
    }
    
    init(message: String, createdAt: Date, id: UUID, sentByUser: Bool) {
        self.message = message
        self.createdAt = createdAt
        self.id = id
        self.sentByUser = sentByUser
    }    
}

// MARK: - Extensions -

extension SecretMessage: Hashable {
    
    static func == (lhs: SecretMessage, rhs: SecretMessage) -> Bool {
        return lhs.id == rhs.id
    }
    
}
