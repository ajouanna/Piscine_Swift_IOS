//
//  File.swift
//  Pods
//
//  Created by Anthony CONTASSOT-VIVIER on 06/04/2017.
//
//

import Foundation

extension Article {

    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var lang: String?
    @NSManaged public var image: NSData?
    @NSManaged public var created: NSDate?
    @NSManaged public var modification: NSDate?
    
    public override var description: String {
        return "\(title ?? "nil") (\(lang ?? "nil")): \(content ?? "nil") -> \((created != nil) ? created!.description(with: Locale(identifier: "en")) : "nil") (\(image?.length ?? 0) bytes)"
    }
}
