//
//  SecondViewController.swift
//  Siri
//
//  Created by Antoine JOUANNAIS on 4/13/17.
//  Copyright © 2017 Antoine JOUANNAIS. All rights reserved.
//

import UIKit
import RecastAI
import ForecastIO
import JSQMessagesViewController

class SecondViewController: JSQMessagesViewController {

    var bot : RecastAIClient?
    let RECASTAI_TOKEN = "3a72b05e8db515aa03f2d931db8fb9ad"
    let FORECASTIO_TOKEN = "a9922194a70ef4300b6af527ff3717a7"
    
    var messages = [JSQMessage]()
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bot = RecastAIClient(token : RECASTAI_TOKEN, language: "en")
        // Do any additional setup after loading the view.
        self.senderId = "weatherApp"
        self.senderDisplayName = "You"
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_: Bool) {
        // messages from someone else
        addMessage(withId: "foo", name: "Mr.Bolt", text: "Hello, this is your weather service")
        addMessage(withId: "foo", name: "Mr.Bolt", text: "What can I do for you?")
        // messages sent from local sender
        // animates the receiving of a new message on the view
        finishReceivingMessage()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        // ici il faut appeler le service recastia
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
        addMessage(withId: senderId, name: senderDisplayName, text: text)
        finishReceivingMessage()
        makeRequest(request : text!)


    }
    
    override func didPressAccessoryButton(_ sender: UIButton) {
        // ne rien faire
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
                
                self.addMessage(withId: "foo", name: "Mr.Bolt", text: "Sorry, I didn't get it...")
                // messages sent from local sender
                // animates the receiving of a new message on the view
                self.finishReceivingMessage()
            }
        }
    }
    
    func processError(_ err: Error) {
        DispatchQueue.main.async { // il faut revenir au thread principal pour toucher a l'affichage
            print("processError : \(err)")
            self.addMessage(withId: "foo", name: "Mr.Bolt", text: "Error")
            // messages sent from local sender
            // animates the receiving of a new message on the view
            self.finishReceivingMessage()        }
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
                    let text = location + " : " + (currentForecast.currently?.summary)! + "\nCurrent temperature : " + String(describing: (currentForecast.currently?.temperature)!) + " °C"
                    self.addMessage(withId: "foo", name: "Mr.Bolt", text: text)
                    // messages sent from local sender
                    // animates the receiving of a new message on the view
                    self.finishReceivingMessage()
                case .failure(let error):
                    //  Uh-oh. We have an error!
                    print("Erreur : \(error)")
                    self.addMessage(withId: "foo", name: "Mr.Bolt", text: "Error")
                    // messages sent from local sender
                    // animates the receiving of a new message on the view
                    self.finishReceivingMessage()                }
            }
        }
    }

}
