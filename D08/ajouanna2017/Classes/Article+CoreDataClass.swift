//
//  Article.swift
//  Pods
//
//  Created by Antoine JOUANNAIS on 4/14/17.
//
//

import UIKit
import CoreData

@objc(Article)
public class Article: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article");
    }
    
    @NSManaged public var titre: String?
    @NSManaged public var content: String?
    @NSManaged public var langue: String?
    @NSManaged public var image: NSData?
    @NSManaged public var dateCreation: NSDate?
    @NSManaged public var dateModification: NSDate?
    
    override public var description: String {
        return "Titre : \(titre)\ncontent : \(content)\nLangue : \(langue)\nDate de creation : \(dateCreation)"
    }
}
