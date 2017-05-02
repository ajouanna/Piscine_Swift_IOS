//
//  SecondViewController.swift
//  D09
//
//  Created by Antoine JOUANNAIS on 4/15/17.
//  Copyright © 2017 Antoine JOUANNAIS. All rights reserved.
//

import UIKit
import acontass2017


class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

   
    var articles : [Article]?
    let manager = ArticleManager()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
   
        tableView.delegate = self
        tableView.dataSource = self
        // pour  que la taille des cellules soit geree automatiquement
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        // pour debuguer, j'ajoute une cellule
/*
        let article1 = manager.newArticle()
        article1.title = "The last of us (best)"
        article1.content = "Ps4 game"
        article1.lang = "en"
        // article1.image = UIImageJPEGRepresentation(UIImage(named: "The Last of Us Remastered")!, 0.2) as NSData?
        article1.created = NSDate()
        article1.modification = NSDate()
        print("viewDidLoad")
        print(article1)
        manager.save()
 */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let preferredLang = NSLocale.preferredLanguages[0]
        print("preferredLang=\(preferredLang)")
        articles = manager.getArticles(withLang: preferredLang)
        for art in articles! {
            print(art)
        }
        tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        print("tableView numberOfRowsInSection")
        return articles!.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            print("tableView cellForRowAt")
            
            
            let article = articles?[indexPath.row]         
          
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "ArticleCell",
                                              for: indexPath) as? ArticleTableViewCell
            cell?.articleTitle?.text = article?.title
            cell?.articleContent.text = article?.content
            if article?.image != nil {
                cell?.articleImage.image = UIImage(data: article?.image as! Data)
            }
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss a"
            var convertedDate: String = dateFormatter.string(from: (article?.created)! as Date)
            
            cell?.dateCreation.text = "C:" + convertedDate
            if article?.modification != article?.created {
                convertedDate = dateFormatter.string(from: (article?.modification)! as Date)
                cell?.dateModification.text = "M:" + convertedDate
            }
            else {
                cell?.dateModification.text = ""
            }
            return cell!
    }
    
    
    // la fonction unwindToSegue doit etre ajouee a la main pour faire un back segue
    // cf. http://stackoverflow.com/questions/24029586/xcode-6-storyboard-unwind-segue-with-swift-not-connecting-to-exit
    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {
        print("On est dans unwindToSegue")
/*
 if let sourceViewController = segue.source as? NewPageViewController, let page = sourceViewController.page {
            let newIndexPath = IndexPath(row: pages.count, section: 0)
            pages.append(page)
            DeathBookTableView.insertRows(at: [newIndexPath], with: .automatic)
        }
 */
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepareSegue")
        if segue.identifier == "createSegue", let destination = segue.destination as? AddArticleViewController {
            print("On est dans le segue createSegue")
            destination.manager = self.manager // ceci permet de tranmettre au segue de destination  le manager instancie ici 
        }
    }
}
