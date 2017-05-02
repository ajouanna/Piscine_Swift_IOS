//
//  SecondViewController.swift
//  D05
//
//  Created by Antoine JOUANNAIS on 4/10/17.
//  Copyright © 2017 Antoine JOUANNAIS. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var locationItems: [Location] = []

    var delegate : LocationProtocol?
    
    @IBOutlet weak var locationTableView: UITableView! {
        didSet {
            locationTableView.delegate = self
            locationTableView.dataSource = self
        }
    }

    fileprivate func initLocationItems() {
        // chargement de la liste des lieux depuis le fichier location.plist
        // (c'est plus propre que de charger la liste en dur dans le code)
        print("chargement de la liste des lieux depuis le fichier location.plist")
        var locations = [Location]()
        let inputFile = Bundle.main.path(forResource: "location", ofType: "plist")
        
        let inputDataArray = NSArray(contentsOfFile: inputFile!)
        
        for inputItem in inputDataArray as! [Dictionary<String, String>] {
            let locationItem = Location(dataDictionary: inputItem)
            locations.append(locationItem)
            print(locationItem)
        }
        
        locationItems = locations
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initLocationItems() // charge les donnees
        delegate?.setPins(locations: locationItems) // initialise tous les pins
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // nous n'avons qu'une seule section
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locationItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell")
         cell?.textLabel?.text = self.locationItems[indexPath.row].name
         cell?.detailTextLabel?.text = self.locationItems[indexPath.row].desc
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        print("DEBUG : SecondViewController.delegate = \(String(describing: self.delegate))")

        delegate?.updateLocation(newLocation: locationItems[row])
        // FIXTHIS : utiliser autre chose que l'index 0 en dur...
        self.tabBarController!.selectedViewController = self.tabBarController!.viewControllers?[0]
    }

 }

protocol LocationProtocol {
    
    func updateLocation(newLocation : Location)
    func setPins(locations : [Location])
}
