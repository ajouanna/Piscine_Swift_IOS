//
//  ArticleManager.swift
//  Pods
//
//  Created by Antoine JOUANNAIS on 4/14/17.
//
//

import Foundation
import CoreData

public class ArticleManager {
    
    public var managedObjectContext : NSManagedObjectContext
    
    public init() {
        var modelUrl: URL!
        if let bundleURL = Bundle(for: Article.self).url(forResource: "ajouanna2017", withExtension: "bundle") {
            guard let frameworkBundle = Bundle(url: bundleURL) else {
                fatalError("Error loading bundle")
            }
            modelUrl = frameworkBundle.url(forResource: "Article", withExtension: "momd")
        }
        else {
            modelUrl = Bundle(for: Article.self).url(forResource: "Article", withExtension: "momd")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelUrl) else {
            fatalError("Error initializing mom from: \(modelUrl)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = psc
        
        let qos = DispatchQoS.QoSClass.background
        let queue = DispatchQueue.global(qos: qos)
        
        queue.async {
            let urls = FileManager.default.urls(for:  FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask)
            let docURL = urls[urls.endIndex-1]
            let storeURL = docURL.appendingPathComponent("ajouanna2017.sqlite", isDirectory: true)
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
                print("Ok")
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
    
    
    public func newArticle() -> Article {
        print("newArticle()")
        return NSEntityDescription.insertNewObject(forEntityName: "Article", into: self.managedObjectContext) as! Article
    }
    
    public func getAllArticles() -> [Article] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        
        do {
            let result = try managedObjectContext.fetch(request) as! [Article]
            return result
        }catch{
            //            fatalError("Failed to fetch artcle")
            return []
        }
    }
    
    public func  getArticles(withLang lang : String) -> [Article] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        request.predicate = NSPredicate(format: "langue == %@", lang)
        
        do {
            let result = try managedObjectContext.fetch(request) as! [Article]
            return result
        }catch{
            return []
            //            fatalError("Failed to fetch lang")
        }
    }
    
    public func getArticles(containString str : String) -> [Article] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        request.predicate = NSPredicate(format: "titre CONTAINS %@ || content CONTAINS %@", str,str)
        
        do{
            let result = try managedObjectContext.fetch(request) as! [Article]
            return result
        } catch {
            return []
        }
    }
    
    public func removeArticle(article : Article) {
        managedObjectContext.delete(article)
    }
    
    public func save() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            }
            catch{
                fatalError("Failure to save content \(error)");
            }
        }
    }
}
