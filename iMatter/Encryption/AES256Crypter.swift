//
//  AES256Crypter.swift
//  iMatter
//
//  Created by Mycah on 9/12/20.
//  Copyright © 2020 Mycah Krason. All rights reserved.
//

import Foundation
import CommonCrypto
import CryptoKit
import Firebase

protocol Cryptable {
    func encrypt(_ string: String) throws -> Data
    func decrypt(_ data: Data) throws -> String
}

struct AES {
    private let key: Data
    private let ivSize: Int         = kCCBlockSizeAES128
    private let options: CCOptions  = CCOptions(kCCOptionPKCS7Padding)
    
    init() throws {
        guard let keyString64 = Private().encryptionKey?.data(using: .ascii)!.sha256 else {throw Error.noEncryptionKey}
        let keyString = keyString64.prefix(32)
        
        guard keyString.count == kCCKeySizeAES256 else {throw Error.invalidKeySize}
        self.key = Data(keyString.utf8)
    }
}

extension AES {
    enum Error: Swift.Error {
        case invalidKeySize
        case generateRandomIVFailed
        case encryptionFailed
        case decryptionFailed
        case dataToStringFailed
        case noEncryptionKey
    }
}

private extension AES {
    func generateRandomIV(for data: inout Data) throws {
        try data.withUnsafeMutableBytes { dataBytes in
            guard let dataBytesBaseAddress = dataBytes.baseAddress else {
                throw Error.generateRandomIVFailed
            }
            
            let status: Int32 = SecRandomCopyBytes(
                kSecRandomDefault,
                kCCBlockSizeAES128,
                dataBytesBaseAddress
            )
            
            guard status == 0 else {
                throw Error.generateRandomIVFailed
            }
        }
    }
}

extension AES: Cryptable {
    func encrypt(_ string: String) throws -> Data {
        let dataToEncrypt = Data(string.utf8)
        let bufferSize: Int = ivSize + dataToEncrypt.count + kCCBlockSizeAES128
        var buffer = Data(count: bufferSize)
        try generateRandomIV(for: &buffer)
        var numberBytesEncrypted: Int = 0
        do {
            try key.withUnsafeBytes { keyBytes in
                try dataToEncrypt.withUnsafeBytes { dataToEncryptBytes in
                    try buffer.withUnsafeMutableBytes { bufferBytes in
                        guard let keyBytesBaseAddress = keyBytes.baseAddress,
                              let dataToEncryptBytesBaseAddress = dataToEncryptBytes.baseAddress,
                              let bufferBytesBaseAddress = bufferBytes.baseAddress else {
                            throw Error.encryptionFailed
                        }
                        
                        let cryptStatus: CCCryptorStatus = CCCrypt( // Stateless, one-shot encrypt operation
                            CCOperation(kCCEncrypt),                // op: CCOperation
                            CCAlgorithm(kCCAlgorithmAES),           // alg: CCAlgorithm
                            options,                                // options: CCOptions
                            keyBytesBaseAddress,                    // key: the "password"
                            key.count,                              // keyLength: the "password" size
                            bufferBytesBaseAddress,                 // iv: Initialization Vector
                            dataToEncryptBytesBaseAddress,          // dataIn: Data to encrypt bytes
                            dataToEncryptBytes.count,               // dataInLength: Data to encrypt size
                            bufferBytesBaseAddress + ivSize,        // dataOut: encrypted Data buffer
                            bufferSize,                             // dataOutAvailable: encrypted Data buffer size
                            &numberBytesEncrypted                   // dataOutMoved: the number of bytes written
                        )
                        
                        guard cryptStatus == CCCryptorStatus(kCCSuccess) else {
                            throw Error.encryptionFailed
                        }
                    }
                }
            }
        } catch {
            throw Error.encryptionFailed
        }
        
        let encryptedData: Data = buffer[..<(numberBytesEncrypted + ivSize)]
        return encryptedData
    }
    
    func decrypt(_ data: Data) throws -> String {
        let bufferSize: Int = data.count - ivSize
        var buffer = Data(count: bufferSize)
        var numberBytesDecrypted: Int = 0
        do {
            try key.withUnsafeBytes { keyBytes in
                try data.withUnsafeBytes { dataToDecryptBytes in
                    try buffer.withUnsafeMutableBytes { bufferBytes in
                        guard let keyBytesBaseAddress = keyBytes.baseAddress,
                              let dataToDecryptBytesBaseAddress = dataToDecryptBytes.baseAddress,
                              let bufferBytesBaseAddress = bufferBytes.baseAddress else {
                            throw Error.encryptionFailed
                        }
                        let cryptStatus: CCCryptorStatus = CCCrypt( // Stateless, one-shot encrypt operation
                            CCOperation(kCCDecrypt),                // op: CCOperation
                            CCAlgorithm(kCCAlgorithmAES128),        // alg: CCAlgorithm
                            options,                                // options: CCOptions
                            keyBytesBaseAddress,                    // key: the "password"
                            key.count,                              // keyLength: the "password" size
                            dataToDecryptBytesBaseAddress,          // iv: Initialization Vector
                            dataToDecryptBytesBaseAddress + ivSize, // dataIn: Data to decrypt bytes
                            bufferSize,                             // dataInLength: Data to decrypt size
                            bufferBytesBaseAddress,                 // dataOut: decrypted Data buffer
                            bufferSize,                             // dataOutAvailable: decrypted Data buffer size
                            &numberBytesDecrypted                   // dataOutMoved: the number of bytes written
                        )
                        
                        guard cryptStatus == CCCryptorStatus(kCCSuccess) else {
                            throw Error.decryptionFailed
                        }
                    }
                }
            }
        } catch {
            throw Error.encryptionFailed
        }
        
        let decryptedData: Data = buffer[..<numberBytesDecrypted]
        guard let decryptedString = String(data: decryptedData, encoding: .utf8) else {
            throw Error.dataToStringFailed
        }
        
        return decryptedString
    }
}

extension Data {
    public var sha256: String {
        if #available(iOS 13.0, *) {
            return hexString(SHA256.hash(data: self).makeIterator())
        } else {
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            self.withUnsafeBytes { bytes in
                _ = CC_SHA256(bytes.baseAddress, CC_LONG(self.count), &digest)
            }
            return hexString(digest.makeIterator())
        }
    }
    
    private func hexString(_ iterator: Array<UInt8>.Iterator) -> String {
        return iterator.map { String(format: "%02x", $0) }.joined()
    }
}
