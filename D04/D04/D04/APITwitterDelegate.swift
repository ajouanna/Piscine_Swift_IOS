//
//  APITwitterDelegate.swift
//  D04
//
//  Created by Antoine JOUANNAIS on 4/8/17.
//  Copyright © 2017 Antoine JOUANNAIS. All rights reserved.
//

import Foundation

protocol APITwitterDelegate : class { // le mot cle class permet d'imposer que ce protocol ne soit utilise que par des classes
    func processTweet(_ tweets : [Tweet])
    func processError(_ error : NSError)
}
