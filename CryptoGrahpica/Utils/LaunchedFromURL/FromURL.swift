//
//  FromURL.swift
//  CryptoGrahpica
//
//  Created by test on 3/23/19.
//  Copyright © 2019 cg. All rights reserved.
//

import UIKit

class FromURL: NSObject {
    static var shared = FromURL()
    
    var newValueSet: (()->())?
    
    var imageURL: URL? {
        didSet {
            newValueSet?()
        }
    }
}
