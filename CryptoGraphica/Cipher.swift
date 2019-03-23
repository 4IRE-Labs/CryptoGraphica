//
//  Cipher.swift
//  CryptoGraphica
//
//  Created by ikar on 3/23/19.
//  Copyright © 2019 io.cryptographica. All rights reserved.
//

import Foundation
import CommonCrypto

class Cipher {
    private static let ivData = "CryptoGraphica".data(using:.utf8)!
    
    public class func encrypt(message: String, key: String) -> Data {
        let messageData = message.data(using:.utf8)!
        let keyData = key.data(using:.utf8)!
        return Cipher.doCryptOperation(data: messageData, keyData: keyData, ivData: ivData, operation: kCCEncrypt)
    }
    
    public class func decrypt(data: Data, key: String) -> String? {
        let keyData = key.data(using:.utf8)!
        let decryptedData = Cipher.doCryptOperation(data:data, keyData:keyData, ivData:ivData, operation:kCCDecrypt)
        
        return String(bytes:decryptedData, encoding:.utf8)
    }
    
    private class func doCryptOperation(data: Data, keyData: Data, ivData: Data, operation: Int) -> Data {
        let cryptLength  = size_t(data.count + kCCBlockSizeAES128)
        var cryptData = Data(count:cryptLength)
        
        let keyLength = size_t(kCCKeySizeAES128)
        let options = CCOptions(kCCOptionPKCS7Padding)
        
        
        var numBytesEncrypted :size_t = 0
        
        let cryptStatus = cryptData.withUnsafeMutableBytes {cryptBytes in
            data.withUnsafeBytes {dataBytes in
                ivData.withUnsafeBytes {ivBytes in
                    keyData.withUnsafeBytes {keyBytes in
                        CCCrypt(CCOperation(operation),
                                CCAlgorithm(kCCAlgorithmAES),
                                options,
                                keyBytes, keyLength,
                                ivBytes,
                                dataBytes, data.count,
                                cryptBytes, cryptLength,
                                &numBytesEncrypted)
                    }
                }
            }
        }
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData.removeSubrange(numBytesEncrypted..<cryptData.count)
            
        } else {
            print("Error: \(cryptStatus)")
        }
        
        return cryptData;
    }
}

