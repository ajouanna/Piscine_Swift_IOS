//
//  ViewController.swift
//  D04
//
//  Created by Antoine JOUANNAIS on 4/8/17.
//  Copyright © 2017 Antoine JOUANNAIS. All rights reserved.
//

import UIKit

class ViewController: UIViewController, APITwitterDelegate, UITableViewDataSource, UITableViewDelegate {
    
	// changer les cles
    let consumerKey : String = "xxxxx"
    let consumerSecret : String = "yyyyyy"
    var token : String?
    var apiController : APIController?
    var tweets : [Tweet] = []
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        initToken()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initToken() {
        let bearer_credentials = ((consumerKey + ":" + consumerSecret).data(using: String.Encoding.utf8))?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let url = URL(string: "https://api.twitter.com/oauth2/token")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Basic " + bearer_credentials!, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            print(response!)
            guard let data = data, error == nil else {
                print(error!)
                return
            }
            do {
                if let dic: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    print(dic)
                    self.token = (dic["access_token"] as? String)!
                    print("token recupéré de twitter : \(String(describing: self.token))")
                    self.apiController = APIController(delegate: self, token: self.token!)
                    self.apiController?.getFromTwitter(str: "ecole 42", nbr: 100)
                }
            }
            catch (let err) {
                print(err)
            }
        }
        task.resume()
    }
    
    
    func processTweet(_ tweets : [Tweet]) {
        // on recupere les tweets
        print("processTweet")
        self.tweets = tweets
        // puis on les trace dans la console
        for t in tweets {
            print(t)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func processError(_ error : NSError) {
        print("error: \(error)")

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // nous n'avons qu'une seule section
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection : \(self.tweets.count)")
        return self.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt")
        var cellRet : UITableViewCell?
        //let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell") as? TweetTableViewCell
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCellId", for: indexPath) as? TweetTableViewCell  {
            cell.titre.text = self.tweets[indexPath.row].name
            cell.dateTweet.text = self.tweets[indexPath.row].date
            cell.contenu?.text = self.tweets[indexPath.row].text
            print(cell)
            cellRet = cell
        }
        return cellRet!
    }
    
}
