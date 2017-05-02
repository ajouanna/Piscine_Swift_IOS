//
//  ViewController.swift
//  acontass2017
//
//  Created by acontass on 04/06/2017.
//  Copyright (c) 2017 acontass. All rights reserved.
//

import UIKit
import acontass2017

class ViewController: UIViewController {
    
    let manager = ArticleManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
/*        for article in manager.getAllArticles() {
            manager.removeArticle(article: article)
        }
        manager.save()*/
        
        print("All articles :")
        print(manager.getAllArticles())

        let article1 = manager.newArticle()
        article1.title = "The last of us (best)"
        article1.content = "Ps4 game"
        article1.lang = "en"
        article1.image = UIImageJPEGRepresentation(UIImage(named: "The Last of Us Remastered")!, 0.2) as NSData?
        article1.created = NSDate()
        article1.modification = NSDate()
        
        let article2 = manager.newArticle()
        article2.title = "Final Fantasy XV"
        article2.content = "Ps4 game"
        article2.lang = "ja"
        article2.image = UIImageJPEGRepresentation(UIImage(named: "Final Fantasy XV")!, 0.2) as NSData?
        article2.created = NSDate(timeIntervalSinceNow: TimeInterval(exactly: -834957.0) ?? 0)
        article2.modification = NSDate(timeIntervalSinceNow: TimeInterval(exactly: -8234.0) ?? 0)
        
        let article3 = manager.newArticle()
        article3.title = "Overwatch"
        article3.content = "Pc game (best)"
        article3.lang = "en"
        article3.image = UIImageJPEGRepresentation(UIImage(named: "Overwatch")!, 0.2) as NSData?
        article3.created = NSDate()
        article3.modification = NSDate()
        
        let article4 = manager.newArticle()
        article4.title = "Assassins creed unity"
        article4.content = "Ps4 game"
        article4.lang = "fr"
        article4.image = UIImageJPEGRepresentation(UIImage(named: "Assassins creed unity")!, 0.2) as NSData?
        article4.created = NSDate()
        article4.modification = NSDate()

        let LangEn = manager.getArticles(withLang: "en")
        print("manager.getArticles(withLang: \"en\") :")
        print(LangEn)
        
        print("manager.getArticles(containString: \"best\")")
        print(manager.getArticles(containString: "best"))

        print("Remove all \"en\" articles !")
        for article in LangEn {
            manager.removeArticle(article: article)
        }
        
        print("All articles one by one :")
        for article in manager.getAllArticles() {
            print(article.description)
        }

        manager.save()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

