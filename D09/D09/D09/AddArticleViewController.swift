//
//  AddArticleViewController.swift
//  D09
//
//  Created by Antoine JOUANNAIS on 4/15/17.
//  Copyright © 2017 Antoine JOUANNAIS. All rights reserved.
//

import UIKit
import acontass2017

class AddArticleViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let pickerController = UIImagePickerController()
    var manager : ArticleManager?
    
    @IBOutlet weak var articleTitle: UITextField!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var articleContent: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func saveArticle(_ sender: UIBarButtonItem) {
        print("saveArticle")
        // creer l'article et le sauver
        if let titre = self.articleTitle.text, !titre.isEmpty {
            let newArt = manager?.newArticle()
            newArt?.title = self.articleTitle.text
            newArt?.content = articleContent.text
            newArt?.created = NSDate()
            newArt?.modification = newArt?.created
            newArt?.lang = NSLocale.preferredLanguages[0]
            if imageView.image != nil {
                if let imageData = UIImageJPEGRepresentation(imageView.image!, 1) {
                    newArt?.image = imageData as NSData?
                } else {
                    // handle failed conversion
                    print("saveArticle : jpg error")
                }
            }

            manager?.save()
        
            performSegue(withIdentifier: "unwindSegue", sender: self)
            return
        }
        print("Oups, le titre est vide, on reste ici")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerController.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

   @IBAction func openLibrary(_ sender: UIButton) {
        showPickerLibrairy()
    }
    
    @IBAction func openCamera(_ sender: UIButton) {
        showPickerCamera()
    }
    
    func showPickerLibrairy() {
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            pickerController.sourceType = .photoLibrary
            present(pickerController, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Alert", message: "No Library available", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showPickerCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            pickerController.sourceType = .camera
            present(pickerController, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Alert", message: "No Camera available", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("imagePickerController didFinishPickingMediaWithInfo")
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        } else{
            print("Something went wrong")
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindSegue", let destination = segue.destination as? SecondViewController {
            print("je vais de AddArticleViewController vers SecondViewController=\(destination)")
        }
    }
}
