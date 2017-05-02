//
//  Shape.swift
//  D06
//
//  Created by Antoine JOUANNAIS on 4/11/17.
//  Copyright © 2017 Antoine JOUANNAIS. All rights reserved.
//

import UIKit

// cette classe represente aleatoirement un carre ou un cercle, de couleur aleatoire
class Shape: UIView {
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var size : CGFloat = 100
    var isCircle = false
    init(point: CGPoint, maxwidth: CGFloat, maxheight: CGFloat ) {
        var x = point.x
        var y = point.y
        // eviter que les formes sortent du cadre
        if x+size/2 > maxwidth {
            x -= size/2
        }
        if y+size/2 > maxheight {
            y -= size/2
        }
        
        // generer aleatoirement un carre ou un cercle
        let random = Int(arc4random_uniform(2)) // mettre a 2 pour avoir aussi des cercles
        switch random {
        case 0 :
            super.init(frame: CGRect(x: x, y: y, width: size, height: size))
        default:
            super.init(frame: CGRect(x: x, y: y, width: size, height: size))
            self.layer.cornerRadius = size/2
            self.isCircle = true
        }
        // couleur aleatoire
        self.backgroundColor = getRandomColor()
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    
    func getRandomColor() -> UIColor {
        let randomRed:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomGreen:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomBlue:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }

}
