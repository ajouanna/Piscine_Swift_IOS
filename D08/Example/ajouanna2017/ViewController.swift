//
//  ViewController.swift
//  ajouanna2017
//
//  Created by ajouanna on 04/14/2017.
//  Copyright (c) 2017 ajouanna. All rights reserved.
//

import UIKit
import ajouanna2017

class ViewController: UIViewController {
    let articleManager = ArticleManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.        
        let article1 : Article = articleManager.newArticle()
        
        article1.titre = "Titre 1"
        article1.content = "Contenu de l'article 1"
        article1.dateCreation = NSDate()
        article1.dateModification = NSDate()
        article1.langue = "fr"
        articleManager.save()
        
        let article2 : Article = articleManager.newArticle()
        
        article2.titre = "Title 2"
        article2.content = "Content of article 2"
        article2.dateCreation = NSDate()
        article2.dateModification = NSDate()
        article2.langue = "en"
        articleManager.save()
        
        
        print(articleManager.getAllArticles())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

