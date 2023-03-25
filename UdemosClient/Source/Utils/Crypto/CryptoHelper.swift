//
//  CryptoHelper.swift
//  UdemosClient
//
//  Created by Sinisa Abramovic on 21.03.2023..
//

import Foundation
import CryptoSwift
import CommonCrypto

final class CryptoHelper {
    
    // MARK: - Public static properties -
    
    static func generateKeyIVFromPrivateKeyPEM(privateKeyPEM: String) -> (key: Data, iv: Data)? {
        let keyLength = 32
        let ivLength = 16
        
        // Remove PEM header and footer
        let base64KeyData = privateKeyPEM
            .replacingOccurrences(of: "-----BEGIN PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "-----END PRIVATE KEY-----", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
        
        guard let privateKeyData = Data(base64Encoded: base64KeyData) else {
            return nil
        }
        
        var digest = Data(count: Int(CC_SHA512_DIGEST_LENGTH))
        _ = privateKeyData.withUnsafeBytes { privateKeyBytes in
            digest.withUnsafeMutableBytes { digestBytes in
                CC_SHA512(privateKeyBytes.baseAddress, CC_LONG(privateKeyData.count), digestBytes.bindMemory(to: UInt8.self).baseAddress)
            }
        }
        
        if keyLength > digest.count || ivLength > digest.count {
            return nil
        }
        
        let keyData = digest.subdata(in: 0..<keyLength)
        let ivData = digest.subdata(in: keyLength..<(keyLength + ivLength))
        
        return (key: keyData, iv: ivData)
    }
    
    static func readPrivateKeyPEMFromFile(filename: String) -> String? {
        guard
            let path = Bundle.main.path(forResource: filename, ofType: "pem")
        else {
            return nil
        }
        
        do {
            let privateKeyPEM = try String(contentsOfFile: path, encoding: .utf8)
            return privateKeyPEM
        } catch {
            return nil
        }
    }
}
