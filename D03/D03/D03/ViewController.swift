//
//  ViewController.swift
//  D03
//
//  Created by Antoine JOUANNAIS on 4/7/17.
//  Copyright © 2017 Antoine JOUANNAIS. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var galleryItems: [GalleryItem] = []

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate func initGalleryItems() {
        // chargement de la liste des images depuis le fichier items.plist
        // (c'est plus propre que de charger la liste en dur dans le code)
        print("chargement de la liste des images depuis le fichier items.plist")
        var items = [GalleryItem]()
        let inputFile = Bundle.main.path(forResource: "items", ofType: "plist")
        
        let inputDataArray = NSArray(contentsOfFile: inputFile!)
        
        for inputItem in inputDataArray as! [Dictionary<String, String>] {
            let galleryItem = GalleryItem(dataDictionary: inputItem)
            items.append(galleryItem)
        }
        
        galleryItems = items
        print(galleryItems)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initGalleryItems()
        collectionView.reloadData()
    }
    
    func setGalleryItem(_ item:GalleryItem, cell: GalleryItemCollectionViewCell) {

        let url = URL(string: item.itemImage)
        //code en asynchrone
        cell.itemActivityIndicator.hidesWhenStopped = true
        cell.itemActivityIndicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data, error == nil else {
                cell.itemActivityIndicator.stopAnimating()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                print("setGalleryItem: impossible d'acceder à \(item.itemImage)")
                let alert = UIAlertController(title: "Error", message: "Impossible d'acceder à l'url \(item.itemImage)", preferredStyle: .alert)
                
                let alertAction = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
                alert.addAction(alertAction)
                
                self.present(alert, animated: true, completion: nil)
                cell.itemActivityIndicator.stopAnimating()

                return
                //throw error
            }
            
            DispatchQueue.main.async() {
                cell.itemImageView.image = UIImage(data: data)
                cell.itemActivityIndicator.stopAnimating()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        
        task.resume()
    }

    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryItemCollectionViewCell", for: indexPath) as! GalleryItemCollectionViewCell
        setGalleryItem(galleryItems[indexPath.row], cell: cell)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let commentView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "GalleryItemCommentView", for: indexPath) as! GalleryItemCommentView
        
        // commentView.commentLabel.text = "Supplementary view of kind \(kind)"
        commentView.commentLabel.text = "Images"
        
        return commentView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /*
        let alert = UIAlertController(title: "didSelectItemAtIndexPath:", message: "Indexpath = \(indexPath)", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
        alert.addAction(alertAction)
        
        self.present(alert, animated: true, completion: nil)
        */
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let picDimension = self.view.frame.size.width / 4.0
        return CGSize(width: picDimension, height: picDimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let leftRightInset = self.view.frame.size.width / 6.0
        return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
    }
}

