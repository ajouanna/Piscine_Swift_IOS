//
//  ViewController.swift
//  rush01
//
//  Created by Anthony CONTASSOT-VIVIER on 11/04/2017.
//  Copyright © 2017 Anthony CONTASSOT-VIVIER. All rights reserved.
//

import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet var textFieldsCollection: [UITextField]!
    @IBOutlet weak var userLocationButton: UIButton!
    @IBOutlet weak var drawButton: UIButton!
    @IBOutlet weak var directionTypeSegment: UISegmentedControl!
    @IBOutlet weak var routeButton: UIButton!
    @IBOutlet weak var navigateButton: UIButton!
    
    fileprivate var completer = MKLocalSearchCompleter()
    fileprivate let tableView = UITableView()
    private let locationManager = CLLocationManager()

    fileprivate var locations: (departure: (item: MKMapItem, annotation: MKPointAnnotation)?, arrival: (item: MKMapItem, annotation: MKPointAnnotation)?) = (nil, nil)
    
    fileprivate var route: MKRoute?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        completer.delegate = self
        completer.filterType = .locationsOnly
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: textFieldsCollection.first!.frame.origin.x + 5,
                                 y: textFieldsCollection.first!.frame.origin.y + textFieldsCollection.first!.frame.height,
                                 width: textFieldsCollection.first!.frame.width + textFieldsCollection.first!.clearButtonRect(forBounds: textFieldsCollection.first!.frame).width + 10,
                                 height: 44)
        view.addSubview(tableView)
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 5
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
        if CLLocationManager.headingAvailable() {
            locationManager.headingFilter = 5
            locationManager.startUpdatingHeading()
        }
        drawButton.setTitle(String.localized("Remove Route !"), for: .selected)
        routeButton.alpha = 0
        map.setUserTrackingMode(.followWithHeading, animated: true)
    }
    
    // MARK: Actions methods:
    
    @IBAction func locationButtonTouched() {
        map.setRegion(MKCoordinateRegion(center: map.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
    }
    
    @IBAction func changeMapType(_ sender: UISegmentedControl) {
        map.mapType = MKMapType(rawValue: UInt(sender.selectedSegmentIndex))!
        userLocationButton.isSelected = (sender.selectedSegmentIndex > 0) ? true : false
    }
    
    @IBAction func drawTapped(_ sender: UIButton) {
        if sender.isSelected {
            map.removeOverlays(self.map.overlays)
            UIView.animate(withDuration: 0.5) {
                self.routeButton.alpha = 0
            }
            directionTypeSegment.isEnabled = true
        }
        else {
            if locations.departure == nil || locations.arrival == nil {
                present(UIAlertController.createAlert(title: String.localized("Error"), message: String.localized("Departure and arrival are both required."), buttons: String.localized("Cancel"), completion: nil), animated: true, completion: nil)
                return
            }
            let directionRequest = MKDirectionsRequest()
            directionRequest.source = locations.departure?.item
            directionRequest.destination = locations.arrival?.item
            directionRequest.transportType = MKDirectionsTransportType(rawValue: UInt(directionTypeSegment.selectedSegmentIndex + 1))
            let directions = MKDirections(request: directionRequest)
            directions.calculate {
                (response, error) -> Void in
                guard let response = response else {
                    if let error = error {
                        sender.isSelected = !sender.isSelected
                        self.present(UIAlertController.createAlert(title: String.localized("Error"), message: error.localizedDescription, buttons: String.localized("Cancel"), completion: nil), animated: true, completion: nil)
                    }
                    return
                }
                if let route = response.routes.first {
                    self.directionTypeSegment.isEnabled = false
                    UIView.animate(withDuration: 0.5) {
                        self.routeButton.alpha = 1
                    }
                    self.route = route
                    self.map.removeOverlays(self.map.overlays)
                    self.map.add((route.polyline), level: .aboveRoads)
                    let rect = route.polyline.boundingMapRect
                    self.map.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
                }
            }
        }
        sender.isSelected = !sender.isSelected
    }

    @IBAction func goTapped(_ sender: Any) {
        if locations.departure == nil || locations.arrival == nil {
            present(UIAlertController.createAlert(title: String.localized("Error"), message: String.localized("Departure and arrival are both required."), buttons: String.localized("Cancel"), completion: nil), animated: true, completion: nil)
            return
        }
        locations.departure?.item.name = textFieldsCollection.first?.text
        locations.arrival?.item.name = textFieldsCollection.last?.text
        if let departure = locations.departure, let arrival = locations.arrival {
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            MKMapItem.openMaps(with: [departure.0, arrival.0], launchOptions: launchOptions)
        }
    }
    
    fileprivate func getAddress(_ placemark: CLPlacemark) -> String {
        var address = placemark.subThoroughfare ?? ""
        address += (placemark.thoroughfare != nil) ? " " + placemark.thoroughfare! : ""
        address += (placemark.subLocality != nil) ? " " + placemark.subLocality! : ""
        address += (placemark.subAdministrativeArea != nil) ? " " + placemark.administrativeArea! : ""
        address += (placemark.postalCode != nil) ? " " + placemark.postalCode! : ""
        address += (placemark.country != nil) ? " " + placemark.country! : ""
        return address
    }
    
    @IBAction func longPressAction(_ sender: UILongPressGestureRecognizer) {
        let textFirstField = textFieldsCollection.first!.text?.replacingOccurrences(of: " ", with: "") ?? ""
        let textLastField = textFieldsCollection.last!.text?.replacingOccurrences(of: " ", with: "") ?? ""
        if sender.state == UIGestureRecognizerState.began && (textFirstField == "" || textLastField == "") {
            let touchPoint = sender.location(in: map)
            let coordinate = map.convert(touchPoint, toCoordinateFrom: map)
            let touchedLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(touchedLocation) { (placemarks, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let placemark = placemarks?.first {
                    let annotation = ColoredPointAnnotation()
                    annotation.subtitle = self.getAddress(placemark)
                    if textFirstField == "" {
                        annotation.pinColor = .green
                        annotation.title = String.localized("Departure :")
                        self.textFieldsCollection.first!.textColor = .black
                        self.textFieldsCollection.first!.text = annotation.subtitle
                        self.locations.departure = (MKMapItem(placemark: MKPlacemark(placemark: placemark)), annotation)
                    }
                    else {
                        self.textFieldsCollection.last!.textColor = .black
                        annotation.title = String.localized("Arrival :")
                        self.textFieldsCollection.last!.text = annotation.subtitle
                        self.locations.arrival = (MKMapItem(placemark: MKPlacemark(placemark: placemark)), annotation)
                    }
/*                    if self.locations.departure != nil && self.locations.arrival != nil {
                        self.drawButton.isEnabled = false
                        self.navigateButton.isEnabled = false
                    }*/
                    annotation.coordinate = placemark.location?.coordinate ?? coordinate
                    self.map.addAnnotation(annotation)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        tableView.alpha = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSteps", let dest = segue.destination as? StepsViewController {
            dest.route = route
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

// MARK: CLLocationManagerDelegate extension:

extension ViewController: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        userLocationButton.isHidden = (status != .authorizedWhenInUse) ? true : false
    }
    
}

// MARK: MKMapViewDelegate extension:

extension ViewController: MKMapViewDelegate {
    
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)
        renderer.lineWidth = 3
        return renderer
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        annotationView.pinTintColor = (annotation as? ColoredPointAnnotation)?.pinColor ?? .red
        annotationView.canShowCallout = true
        return annotationView
    }
    
    public func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let location = userLocation.location {
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let placemark = placemarks?.first {
                    mapView.userLocation.subtitle = self.getAddress(placemark)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

// MARK: MKLocalSearchCompleterDelegate extension:

extension ViewController: MKLocalSearchCompleterDelegate {

    public func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        tableView.reloadData()
    }
    
}

// MARK: UITextFieldDelegate extension:

extension ViewController: UITextFieldDelegate {

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if completer.isSearching {
            completer.cancel()
        }
        completer.queryFragment = textField.text ?? ""
        tableView.frame.origin.y = textFieldsCollection[textField.tag].frame.origin.y + textField.frame.height
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        completer = MKLocalSearchCompleter()
        completer.delegate = self
        completer.filterType = .locationsOnly
        tableView.reloadData()
        tableView.frame.origin.y = textFieldsCollection[textField.tag].frame.origin.y + textFieldsCollection[textField.tag].frame.height
        tableView.alpha = 1
        textField.textColor = .black
        tableView.frame.size.height = (CLLocationManager.authorizationStatus() == .authorizedWhenInUse) ? 44 : 0
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        CLGeocoder().geocodeAddressString(textField.text ?? "") {
            if $0.1 != nil {
                textField.textColor = .red
                return
            }
            if let placemark = $0.0?.first {
                textField.textColor = .black
                let annotation = ColoredPointAnnotation()
                annotation.subtitle = self.getAddress(placemark)
                if textField.tag == 0 {
                    annotation.pinColor = .green
                    annotation.title = String.localized("Departure :")
                    if let departure = self.locations.departure {
                        self.map.removeAnnotation(departure.annotation)
                    }
                    self.locations.departure = (MKMapItem(placemark: MKPlacemark(placemark: placemark)), annotation)
                }
                else {
                    annotation.title = String.localized("Arrival :")
                    if let arrival = self.locations.arrival {
                        self.map.removeAnnotation(arrival.annotation)
                    }
                    self.locations.arrival = (MKMapItem(placemark: MKPlacemark(placemark: placemark)), annotation)
                }
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                }
                self.map.removeOverlays(self.map.overlays)
/*                if self.locations.departure != nil && self.locations.arrival != nil {
                    self.drawButton.isEnabled = false
                    self.navigateButton.isEnabled = false
                }*/
                self.drawButton.isSelected = false
                self.map.addAnnotation(annotation)
            }
        }
        tableView.alpha = 0
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            textFieldsCollection.last!.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        map.removeOverlays(map.overlays)
        if textField.tag == 0 {
            if let departure = locations.departure {
                map.removeAnnotation(departure.annotation)
            }
            locations.departure = nil
        }
        else {
            if let arrival = locations.arrival {
                map.removeAnnotation(arrival.annotation)
            }
            locations.arrival = nil
        }
        UIView.animate(withDuration: 0.5) {
            self.routeButton.alpha = 0
        }
        directionTypeSegment.isEnabled = true
        drawButton.isSelected = false
//        drawButton.isEnabled = false
//        navigateButton.isEnabled = false
        return true
    }
    
}

// MARK: UITableViewDelegate extension:

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let field = (textFieldsCollection.first!.isFirstResponder) ? textFieldsCollection.first! : textFieldsCollection.last!
        let index = (CLLocationManager.authorizationStatus() == .authorizedWhenInUse) ? indexPath.row - 1 : indexPath.row
        field.text = (CLLocationManager.authorizationStatus() == .authorizedWhenInUse && indexPath.row == 0) ? map.userLocation.subtitle ?? "" : ((completer.results[index].subtitle != "") ? completer.results[index].subtitle : completer.results[index].title)
        field.resignFirstResponder()
    }
    
}

// MARK: UITableViewDataSource extension:

extension ViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.frame.size.height = (completer.results.count > 5) ? 5 * 44 : CGFloat(completer.results.count) * 44
        return (CLLocationManager.authorizationStatus() == .authorizedWhenInUse) ? 1 + completer.results.count : completer.results.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse && indexPath.row == 0 {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.textLabel?.text = String.localized("My Location")
            cell.detailTextLabel?.text = map.userLocation.subtitle
            return cell
        }
        let index = (CLLocationManager.authorizationStatus() == .authorizedWhenInUse) ? indexPath.row - 1 : indexPath.row
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = completer.results[index].title
        cell.detailTextLabel?.text = completer.results[index].subtitle
        return cell
    }
    
}

