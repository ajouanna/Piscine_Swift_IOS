//
//  ArticleManager.swift
//  Pods
//
//  Created by Anthony CONTASSOT-VIVIER on 06/04/2017.
//
//

import Foundation
import CoreData

public class ArticleManager {
    
    public var managedObjectContext: NSManagedObjectContext
    
    public init() {
        var modelUrl: URL!
        if let bundleURL = Bundle(for: Article.self).url(forResource: "acontass2017", withExtension: "bundle") {
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
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
        queue.async {
            guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                fatalError("Unable to resolve document directory")
            }
            let storeURL = docURL.appendingPathComponent("Article.sqlite")
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            }
            catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
    
    public func newArticle() -> Article {
        return NSEntityDescription.insertNewObject(forEntityName: "Article", into: managedObjectContext) as! Article
    }
    
    private func search(entity: String, with predicate: NSPredicate?) -> [Any] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        do {
            let results = try managedObjectContext.fetch(request)
            return results
        }
        catch {
            return []
        }
    }
    
    public func getAllArticles() -> [Article] {
        return search(entity: "Article", with: nil) as? [Article] ?? []
    }
    
    public func getArticles(withLang lang : String) -> [Article] {
        return search(entity: "Article", with: NSPredicate(format: "lang = %@", lang)) as? [Article] ?? []
    }
    
    public func getArticles(containString str : String) -> [Article] {
        return search(entity: "Article", with: NSPredicate(format: "title CONTAINS %@ || content CONTAINS %@", str, str)) as? [Article] ?? []
    }
    
    public func removeArticle(article : Article) {
        managedObjectContext.delete(article)
    }
    
    public func save() {
        if managedObjectContext.hasChanges {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).sync {
                do {
                    try managedObjectContext.save()
                }
                catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
