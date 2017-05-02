//
//  Tweet.swift
//  D04
//
//  Created by Antoine JOUANNAIS on 4/8/17.
//  Copyright © 2017 Antoine JOUANNAIS. All rights reserved.
//

import Foundation

struct Tweet : CustomStringConvertible {
    
    let name : String
    let text : String
    let date : String
    var description: String {
        return "(\(name) : \(text)\n \(date))"
    }
}
