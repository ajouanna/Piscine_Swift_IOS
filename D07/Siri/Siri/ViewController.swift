//
//  ViewController.swift
//  Siri
//
//  Created by Antoine JOUANNAIS on 4/12/17.
//  Copyright © 2017 Antoine JOUANNAIS. All rights reserved.
//

import UIKit
import RecastAI
import ForecastIO

class ViewController: UIViewController {
    var bot : RecastAIClient?
    let RECASTAI_TOKEN = "3a72b05e8db515aa03f2d931db8fb9ad"
    let FORECASTIO_TOKEN = "a9922194a70ef4300b6af527ff3717a7"
    @IBOutlet weak var itemActivityIndicator: UIActivityIndicatorView!

    
    @IBOutlet weak var answer: UILabel!
    
    @IBOutlet weak var question: UITextField!

    @IBAction func goButton(_ sender: UIButton) {
        print("goButton appelé")
        print("contenu du champ de texte : \(question.text)")
        guard let myString = question.text, !myString.isEmpty else {
            print("String is nil or empty.")
            return
        }
        itemActivityIndicator.startAnimating()
        makeRequest(request : question.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        itemActivityIndicator.hidesWhenStopped = true
        self.bot = RecastAIClient(token : RECASTAI_TOKEN, language: "en")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     Make text request to Recast.AI API
     */
    func makeRequest(request: String)
    {
        //Call makeRequest with string parameter to make a text request
        self.bot?.textRequest(request, successHandler: recastRequestDone, failureHandle: processError)
    }
    /**
     Method called when the request was successful
     
     - parameter response: the response returned from the Recast API
     
     - returns: void
     */
    func recastRequestDone(_ response : Response)
    {
        print("recastRequestDone: \(response)")
        if let location = response.get(entity: "location") {
            print(location)
            // answer.text = "Location found : \(location["raw"]!), processing in progress..."
            callForecast(location: location["raw"] as! String, lat: location["lat"] as! Double, lng: location["lng"] as! Double)
        }
        else {
            DispatchQueue.main.async { // il faut revenir au thread principal pour toucher a l'affichage

                self.answer.text = "Sorry, I didn't get it"
                self.itemActivityIndicator.stopAnimating()
            }
        }
    }
    
    func processError(_ err: Error) {
        DispatchQueue.main.async { // il faut revenir au thread principal pour toucher a l'affichage
            print("processError : \(err)")
            self.answer.text = "Error"
        }
    }
    
    func callForecast(location: String, lat: Double, lng: Double){
        print("callForecast")
        let client = DarkSkyClient(apiKey: FORECASTIO_TOKEN)
        client.units = .si
        
        /*
        // Move to a background thread to do some long running work
        DispatchQueue.global(qos: .userInitiated).async {
            // Do long running task here
            // Bounce back to the main thread to update the UI
            DispatchQueue.main.async {
                self.friendLabel.text = "You are following \(friendCount) accounts"
            }
        }
        */
        
        
        client.getForecast(latitude: lat, longitude: lng) { result in
            DispatchQueue.main.async { // il faut revenir au thread principal pour toucher a l'affichage
            switch result {
            case .success(let currentForecast, let requestMetadata):
                //  We got the current forecast!
                print("on a recu une reponse")
                print("currentForecast : \(currentForecast)")
                print("requestMetadata : \(requestMetadata)")
                self.answer.text = location + " : " + (currentForecast.currently?.summary)! + "\nCurrent temperature : " + String(describing: (currentForecast.currently?.temperature)!) + " °C"
            case .failure(let error):
                //  Uh-oh. We have an error!
                print("Erreur : \(error)")
                self.answer.text = "Error"
            }
            self.itemActivityIndicator.stopAnimating()
            }
        }
    }
    
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        print("prepare appelé")
        /*
        if let channel = sender as? Channel {
            let chatVc = segue.destination as! ChatViewController
            
            chatVc.senderDisplayName = senderDisplayName
            chatVc.channel = channel
            chatVc.channelRef = channelRef.child(channel.id)
        }
 */
    }
    
    
}

