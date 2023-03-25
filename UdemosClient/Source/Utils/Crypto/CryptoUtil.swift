//
//  CryptoManager.swift
//  UdemosClient
//
//  Created by Sinisa Abramovic on 21.03.2023..
//

import Foundation
import CryptoSwift

final class CryptoUtil {
    
    static func encrypt(data: Data, key: Data?, iv: Data?) throws -> Data {
        guard let key = key, let iv = iv else {
            throw APIError.decodingError(NSError(domain: "InvalidKeyOrIV", code: -1, userInfo: nil))
        }
        do {
            let aes = try AES(key: [UInt8](key), blockMode: CBC(iv: [UInt8](iv)), padding: .pkcs7)
            let encryptedData = try aes.encrypt([UInt8](data))
            return Data(encryptedData)
        } catch {
            throw APIError.encryptionError(error)
        }
    }
    
    static func decrypt(data: Data, key: Data?, iv: Data?) throws -> Data {
        guard let key = key, let iv = iv else {
            throw APIError.decodingError(NSError(domain: "InvalidKeyOrIV", code: -1, userInfo: nil))
        }
        do {
            let aes = try AES(key: [UInt8](key), blockMode: CBC(iv: [UInt8](iv)), padding: .pkcs7)
            let decryptedData = try aes.decrypt([UInt8](data))
            return Data(decryptedData)
        } catch {
            throw APIError.decryptionError(error)
        }
    }
}
