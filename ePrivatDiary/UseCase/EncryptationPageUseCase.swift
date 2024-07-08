//
//  EncryptationPageUseCase.swift
//  ePrivatDiary
//
//  Created by Adrian Aranda Campanario on 7/7/24.
//

import Foundation
import CryptoKit

enum ErrorEncryptation: Error {
    case errorEncryptation
    case errorDecryptation
}

protocol EncryptationPageProtocol {
    func encryptationPage(text: String?) throws -> Data?
    func decryptationPage(data: Data) throws -> String?
}

class EncryptationPageUseCase: EncryptationPageProtocol {
    
    private let key: SymmetricKey
    
    init(key: String) {
        self.key = SymmetricKey.init(data: SHA256.hash(data: key.data(using: .utf8)!))
    }
    
    func encryptationPage(text: String?) throws -> Data? {
        guard let data = text?.data(using: .utf8) else {
            throw ErrorEncryptation.errorEncryptation
        }
        do {
            let sealedBox = try AES.GCM.seal(data, using: key)
            return sealedBox.combined
        } catch {
            print("Error \(error.localizedDescription)")
            throw ErrorEncryptation.errorEncryptation
        }
    }
    
    func decryptationPage(data: Data) throws -> String? {
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: data)
            let decryptedData = try AES.GCM.open(sealedBox, using: key)
            return String(data: decryptedData, encoding: .utf8)
        } catch {
            print("Error \(error.localizedDescription)")
            throw ErrorEncryptation.errorDecryptation
        }
    }
}
