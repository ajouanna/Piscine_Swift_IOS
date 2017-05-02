//
//  GalleryItem.swift
//  D03
//
//  Created by Antoine JOUANNAIS on 4/7/17.
//  Copyright © 2017 Antoine JOUANNAIS. All rights reserved.
//

import Foundation

class GalleryItem {
    
    var itemImage: String
    
    init(dataDictionary:Dictionary<String,String>) {
        itemImage = dataDictionary["itemImage"]!
    }
    
    class func newGalleryItem(_ dataDictionary:Dictionary<String,String>) -> GalleryItem {
        return GalleryItem(dataDictionary: dataDictionary)
    }
    
}
