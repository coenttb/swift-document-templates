//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 30/07/2024.
//

import Foundation

internal let base62Characters = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
internal let base62Length = base62Characters.count

extension String {
    public static func base62(length: Int) -> String {
        var result = ""
        for _ in 0..<length {
            let randomIndex = Int(arc4random_uniform(UInt32(base62Length)))
            let randomCharacter = base62Characters[base62Characters.index(base62Characters.startIndex, offsetBy: randomIndex)]
            result.append(randomCharacter)
        }
        return result
    }
}
