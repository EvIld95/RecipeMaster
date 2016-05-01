//
//  RecipeDetailViewController.swift
//  MoodUpLabs
//
//  Created by Pawel Szudrowicz on 29.04.2016.
//  Copyright © 2016 Pawel Szudrowicz. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    var selectedRecipe : Recipe!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var preparingTextView: UITextView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    var facebookStatusInfo : String?
    
    
   func savePhoto(sender: AnyObject) {
        let alert = UIAlertController(title: "Save image!", message: "Would you like to save image in your camera roll?", preferredStyle: .Alert)
        let yesAction = UIAlertAction(title: "Yes", style: .Default) { (action) in
            let imageView = sender as! UIImageView
            let img = imageView.image!
            UIImageWriteToSavedPhotosAlbum(img, self, #selector(RecipeDetailViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
            
        }
        let noAction = UIAlertAction(title: "No", style: .Cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedRecipe.title + " recipe"
        if facebookStatusInfo != nil {
            userNameLabel.text = "Logged as: " + facebookStatusInfo!
        }
        
        leftImageView.userInteractionEnabled = true
        rightImageView.userInteractionEnabled = true
    
        titleLabel.text = selectedRecipe.title
        descriptionTextView.text = selectedRecipe.description
        ingredientsTextView.text = selectedRecipe.ingredients.map(){"-"+$0}.reduce("", combine: { (first, second) -> String! in
            return first+second+("\n")
        })+"\n"
        preparingTextView.text = selectedRecipe.preparing.enumerate().map(){"\($0+1). "+$1}.reduce("", combine: { (first, second) -> String! in
            return first+second+("\n")
        })+"\n"
        
        
        leftImageView.image = selectedRecipe.imgs[0]
        rightImageView.image = selectedRecipe.imgs[1]
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        if (touch.view == leftImageView) || (touch.view == rightImageView) {
            savePhoto(touch.view!)
        }
    }
    
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        var information = ""
        var title = ""
        if error != nil {
            title = "Can't save image!"
            information = "\(error!.description)"
        } else {
            title = "Success!"
            information = "Your image has been saved!"
        }
        
        let alert = UIAlertController(title: title, message: information, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        descriptionTextView.scrollRangeToVisible(NSMakeRange(0, 0))
        ingredientsTextView.scrollRangeToVisible(NSMakeRange(0, 0))
        preparingTextView.scrollRangeToVisible(NSMakeRange(0, 0))
        
    }

}
