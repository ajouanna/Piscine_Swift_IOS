//
//  StringExtension.swift
//  rush01
//
//  Created by Anthony CONTASSOT-VIVIER on 14/04/2017.
//  Copyright © 2017 Anthony CONTASSOT-VIVIER. All rights reserved.
//

import Foundation

extension String {
    
    static public func localized(_ string: String, comment: String = "") -> String {
        return NSLocalizedString(string, comment: comment)
    }
    
}
