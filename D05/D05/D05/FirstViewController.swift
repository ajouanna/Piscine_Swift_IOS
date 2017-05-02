//
//  FirstViewController.swift
//  D05
//
//  Created by Antoine JOUANNAIS on 4/10/17.
//  Copyright © 2017 Antoine JOUANNAIS. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FirstViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, LocationProtocol { // cette classe est deleguee pour la map et pour le location manager
        var locationManager = CLLocationManager() // pour la geolocalisation
        var secondVC : SecondViewController? // pour me definir comme delegue
        @IBOutlet weak var myMapView: MKMapView!
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            locationManager.delegate = self // permet de dire au location manager qu'il doit utiliser le view controller comme delegué
            // FIXTHIS : comment faire autrement que mettre en dur l'index 1 ci-dessous ?
            secondVC = self.tabBarController?.viewControllers?[1] as! SecondViewController?
            secondVC?.delegate = self
            print("DEBUG : secondVC.delegate = \(String(describing: secondVC?.delegate))")
            
            myMapView.delegate = self
            locationManager.requestWhenInUseAuthorization() // fera une demande d'authorisation à l'utilisateur la premier fois
            locationManager.startUpdatingLocation()
            locationManager.distanceFilter = 10
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            myMapView.showsUserLocation = true
            
            // mettre une marque pour l'Ecole 42 et centrer dessus
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: 48.896583, longitude: 2.318971)
            annotation.title = "Ecole 42"
            annotation.subtitle = "L'école des sorciers du code"
            let span = MKCoordinateSpan(latitudeDelta: 0.01,longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
            myMapView.setRegion(region, animated: true)
            
            myMapView.addAnnotation(annotation)
            
        }
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        @IBAction func geoLoc(_ sender: UIButton) {
            // quand on appuie sur ce bouton, il faut se geolocaliser et positioner la carte sur soi en reglant le zoom
            print("Geolocalisation : \(String(describing: locationManager.location?.coordinate))")
            let span = MKCoordinateSpan(latitudeDelta: 0.01,longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: (locationManager.location?.coordinate)!, span: span)
            myMapView.setRegion(region, animated: true)

        }
    
        @IBAction func segButton(_ sender: UISegmentedControl) {
            switch (sender.selectedSegmentIndex) {
            case 0:
                myMapView.mapType = .standard
            case 1:
                myMapView.mapType = .satellite
            default:
                myMapView.mapType = .hybrid
            }
        }
    
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            print("Position mise à jour : \(String(describing: manager.location?.coordinate))")
        }
    
    // mise en oeuvre du protocole LocationProtocole
    func updateLocation(newLocation : Location) {
        print("updateLocation")
        let coord = CLLocationCoordinate2D(latitude: newLocation.latitude, longitude: newLocation.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01,longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coord, span: span)
        myMapView.setRegion(region, animated: true)
    }
    func setPins(locations : [Location]) {
        print("setPins")
        for loc in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)
            annotation.title = loc.name
            annotation.subtitle = loc.desc
            myMapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("mapView : annotation = \(annotation)")
        let identifier = "pin"
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            // view.rightCalloutAccessoryView = UIButton.withType(.detailDisclosure) as UIView
        }
 
        if annotation.subtitle??.range(of:"tourisme") != nil {
            view.pinTintColor = UIColor.green
        }
        else if annotation.subtitle??.range(of:"école") != nil {
            view.pinTintColor = UIColor.blue
        }
        else if annotation.subtitle??.range(of:"sport") != nil {
            view.pinTintColor = UIColor.purple
        }
        else {
            view.pinTintColor = UIColor.red
        }
        return view
    }
}

extension MKPinAnnotationView {
    class func bluePinColor() -> UIColor {
        return UIColor.blue
    }
}

