//
//  APIController.swift
//  D04
//
//  Created by Antoine JOUANNAIS on 4/8/17.
//  Copyright © 2017 Antoine JOUANNAIS. All rights reserved.
//

import Foundation

class APIController {
    weak var delegate : APITwitterDelegate?
    let token : String
    init(delegate: APITwitterDelegate, token: String) {
        self.delegate = delegate
        self.token = token
    }
    func getFromTwitter(str : String, nbr : Int) {
        print("getFromTwitter(\(str), \(nbr))")
        
        var tweets: [Tweet] = []
        
        let q = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let my_mutableURLRequest = NSMutableURLRequest(url: URL(string : "https://api.twitter.com/1.1/search/tweets.json?q=\(q)&count=\(nbr)&lang=fr&result_type=recent")!)
        my_mutableURLRequest.httpMethod = "GET"
        my_mutableURLRequest.setValue("Bearer " +  self.token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: my_mutableURLRequest as URLRequest, completionHandler: {
            (data, response, error) in
            if let err = error {
                if let mon_delegue: APITwitterDelegate = self.delegate {
                    mon_delegue.processError(err as NSError)
                }
            } else if let d = data {
                do {
                    if let responseObject = try JSONSerialization.jsonObject(with: d, options: []) as? [String:AnyObject],
                        let arrayStatuses = responseObject["statuses"] as? [[String:AnyObject]] {
                        print("Data items count: \(arrayStatuses.count)")
                        for status in arrayStatuses {
                            let text = status["text"] as! String
                            let user = status["user"]?["name"]  as! String
                            if let date = status["created_at"] as? String {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
                                if let date = dateFormatter.date(from: date) {
                                    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                                    let newDate = dateFormatter.string(from: date)
                                    tweets.append(Tweet(name: user, text: text, date: newDate))
                                }
                            }
                        }
                    }
                    if let mon_delegue: APITwitterDelegate = self.delegate {
                        mon_delegue.processTweet(tweets)
                    }
                } catch _{
                    print("Connexion lost")
                }
            }
        })
        task.resume()
    }
}
