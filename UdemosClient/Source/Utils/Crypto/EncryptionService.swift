//
//  EncryptionService.swift
//  UdemosClient
//
//  Created by Sinisa Abramovic on 25.03.2023..
//

import Foundation

class EncryptionService {
    private let privateKeyFileName: String
    
    init(privateKeyFileName: String) {
        self.privateKeyFileName = privateKeyFileName
    }
    
    func encrypt(data: Data) throws -> (encryptedData: Data, key: Data, iv: Data) {
        guard
            let privateKey = CryptoHelper.readPrivateKeyPEMFromFile(filename: privateKeyFileName),
            let (key, iv) = CryptoHelper.generateKeyIVFromPrivateKeyPEM(privateKeyPEM: privateKey)
        else {
            throw APIError.decodingError(NSError(domain: "CryptoError", code: -1, userInfo: nil))
        }
        
        let encryptedData = try CryptoUtil.encrypt(data: data, key: key, iv: iv)
        return (encryptedData, key, iv)
    }
    
    func decrypt(data: Data, key: Data, iv: Data) throws -> Data {
        let decryptedData = try CryptoUtil.decrypt(data: data, key: key, iv: iv)
        return decryptedData
    }
}
