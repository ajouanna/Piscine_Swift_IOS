//
//  StepsViewController.swift
//  rush01
//
//  Created by Anthony CONTASSOT-VIVIER on 15/04/2017.
//  Copyright © 2017 Anthony CONTASSOT-VIVIER. All rights reserved.
//

import MapKit

class StepsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    public var route: MKRoute!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 67
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    @IBAction func closeButtonTouched(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension StepsViewController: UITableViewDelegate {
    
}

extension StepsViewController: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return route.steps.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StepCell", for: indexPath) as! StepTableViewCell
        cell.step = route.steps[indexPath.row]
        return cell
    }

}
