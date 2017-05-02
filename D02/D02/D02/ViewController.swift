//
//  ViewController.swift
//  D02
//
//  Created by Antoine JOUANNAIS on 4/5/17.
//  Copyright © 2017 Antoine JOUANNAIS. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var pages: [Page] = [
        Page(name:"Marine La Peine", desc: "Assassinée par son père\nUn jour de pluie\nEn Bretagne", deathDate: Date(timeIntervalSinceNow: 1000))!,
        Page(name:"François Foireux", desc: "Trucidé par sa femme\nA coups de pots-de-vin", deathDate: Date(timeIntervalSinceNow: 1000))!,
        Page(name:"Jack Cheminaux", desc: "Empoisonné par les extra-terrestres", deathDate: Date(timeIntervalSinceNow: 1000))!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        DeathBookTableView.rowHeight = UITableViewAutomaticDimension
        DeathBookTableView.estimatedRowHeight = 140
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var DeathBookTableView: UITableView! {
        didSet {
            DeathBookTableView.delegate = self
            DeathBookTableView.dataSource = self
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Death Book"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // nous n'avons qu'une seule section
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss a"
        let convertedDate: String = dateFormatter.string(from: self.pages[indexPath.row].deathDate)
        
    /*
        let cell = tableView.dequeueReusableCell(withIdentifier: "pageCell")
        cell?.textLabel?.text = self.pages[indexPath.row].name + "  " + convertedDate
        cell?.detailTextLabel?.text = self.pages[indexPath.row].desc
 */
        let cellIdentifier = "PageTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PageTableViewCell  else {
            fatalError("La cellule n'est pas une instance de PageTableViewCell.")
        }
        cell.title?.text = self.pages[indexPath.row].name
        cell.deathDate?.text = convertedDate
        cell.detail?.text = self.pages[indexPath.row].desc
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // cette fontion est appelee juste avant la transition
        if segue.identifier == "newPage"{
            print("On enchaine sur la page de saisie d'une nouvelle page")
            let vc = segue.destination as UIViewController
            vc.navigationItem.title = "Add a person"
        }
    }
    
    // la fonction unwindToSegue doit etre ajouee a la main pour faire un back segue
    // cf. http://stackoverflow.com/questions/24029586/xcode-6-storyboard-unwind-segue-with-swift-not-connecting-to-exit
    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {
        print("On est dans unwindToSegue")
        if let sourceViewController = segue.source as? NewPageViewController, let page = sourceViewController.page {
            let newIndexPath = IndexPath(row: pages.count, section: 0)
            pages.append(page)
            DeathBookTableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
}
