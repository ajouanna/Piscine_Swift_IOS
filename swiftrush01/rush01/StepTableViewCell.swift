//
//  StepTableViewCell.swift
//  rush01
//
//  Created by Anthony CONTASSOT-VIVIER on 15/04/2017.
//  Copyright © 2017 Anthony CONTASSOT-VIVIER. All rights reserved.
//

import MapKit

class StepTableViewCell: UITableViewCell {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    public var step: MKRouteStep! {
        didSet {
            distanceLabel.text = ((step.transportType == MKDirectionsTransportType.automobile) ? String.localized("Navigate") : String.localized("Walk")) + String.localized(" for ") + "\(Int((step.distance > 1000) ? step.distance / 1000 : step.distance.rounded())) " + ((step.distance > 1000) ? "km" : "m") + String.localized(", then")
            instructionsLabel.text = step.instructions
        }
    }

}
