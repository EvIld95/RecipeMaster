//
//  MainViewController.swift
//  MoodUpLabs
//
//  Created by Pawel Szudrowicz on 28.04.2016.
//  Copyright © 2016 Pawel Szudrowicz. All rights reserved.
//

import UIKit

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat(M_PI) / 180.0
    }
}

class MainViewController: UIViewController, FBSDKLoginButtonDelegate {
    @IBOutlet weak var plusButton: PlusButton!
    @IBOutlet weak var fbButton: FBSDKLoginButton!
    @IBOutlet weak var recipeIcon: UIButton!
    @IBOutlet weak var background: UIImageView!
    
    private var dataTask: NSURLSessionDataTask? = nil
    var iconsVisible = false;
    var facebookFirstName: String?
    var facebookLastName: String?
    var facebookImage: UIImage?
    var facebookEmail: String?
    var facebookGender: String?
    var facebookBirthday: String?
    var facebookNavRightButton: UIBarButtonItem?
    
    
    var blurEffectView: UIVisualEffectView!
    var spinnerIndicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "RecipeMaster"
        
        createBlurEffect()
        createSpinner()
    
        let defaultHeight: CGFloat = 1024.0
        for con in plusButton.constraints {
            if con.identifier == "constraint" {
                con.constant = con.constant * (CGFloat(view.frame.size.height) / defaultHeight)
            }
        }
        
        placeIconsOutsideScreen()
        fbButton.delegate = self
        fbButton.readPermissions = ["public_profile","email"]
        let hideIconsGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainViewController.hideIcons))
        self.view.addGestureRecognizer(hideIconsGestureRecognizer)
       
        if FBSDKAccessToken.currentAccessToken() != nil {
                readFacebookInformation()
                createRightButtonItem()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //after placing constraints
        background.clipsToBounds = true
        background.alpha = 0.7
        background.layer.cornerRadius = background.bounds.width / 2
    }
    
    private func createRightButtonItem() {
        facebookNavRightButton = UIBarButtonItem(title: "FB", style: .Plain, target: self, action: #selector(MainViewController.viewFacebookProfile))
        navigationItem.rightBarButtonItem = facebookNavRightButton
    }
    
    private func createSpinner() {
        spinnerIndicator.activityIndicatorViewStyle = .Gray
        spinnerIndicator.hidesWhenStopped = true
        spinnerIndicator.tintColor = UIColor.grayColor()
        spinnerIndicator.center = self.view.center
    }
    
    private func createBlurEffect() {
        let blurEffect = UIBlurEffect(style: .Light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
    }
    
    private func readFacebookInformation()  {
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large), gender, email"]).startWithCompletionHandler { (connection, result, error) -> Void in
            if error == nil {
                self.facebookFirstName = (result.objectForKey("first_name") as? String)!
                self.facebookLastName = (result.objectForKey("last_name") as? String)!
                let imageStr = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                self.facebookImage = UIImage(data: NSData(contentsOfURL: NSURL(string: imageStr)!)!)
                self.facebookEmail = (result.objectForKey("email") as? String)
                self.facebookGender = (result.objectForKey("gender") as? String)!
            }
        }
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        placeIconsOutsideScreen()
    }
    
    @objc private func hideIcons() {
        UIView.animateWithDuration(1, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .CurveEaseInOut, animations: { self.placeIconsOutsideScreen() }) { (_) in
            self.iconsVisible = false
            self.blurEffectView.removeFromSuperview()
        }
        
    }
    
    private func placeIconsOutsideScreen() {
        let translationFB = CGAffineTransformMakeTranslation(0, 400)
        let translationRecipeIcon = CGAffineTransformMakeTranslation(0, 500)
        blurEffectView.alpha = 0
        fbButton.transform = CGAffineTransformRotate(translationFB, CGFloat(270).toRadians())
        recipeIcon.transform = CGAffineTransformRotate(translationRecipeIcon, CGFloat(-270).toRadians())
        plusButton.transform = CGAffineTransformIdentity
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func recipeIconAction(sender: AnyObject) {
        self.view.addSubview(spinnerIndicator)
        spinnerIndicator.startAnimating()
        self.view.userInteractionEnabled = false
        self.downloadRecipeFromWebSite("http://mooduplabs.com/test/info.php")
    }
    
    
    @IBAction func buttonTapped(object: AnyObject) {
        view.addSubview(blurEffectView)
        
        view.bringSubviewToFront(fbButton)
        view.bringSubviewToFront(recipeIcon)
        view.bringSubviewToFront(plusButton)
        
        UIView.animateWithDuration(1, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.4, options: .CurveEaseInOut, animations: {
            self.blurEffectView.alpha = 1.0
            self.fbButton.transform = CGAffineTransformIdentity
            self.recipeIcon.transform = CGAffineTransformIdentity
            self.plusButton.transform = CGAffineTransformMakeRotation(CGFloat(45).toRadians())
        }){ (bool) in self.iconsVisible = true}
    }
        
    
    func downloadRecipeFromWebSite(website: String) {
        let session = NSURLSession.sharedSession()
        guard let url = NSURL(string: website) else {
            let alert = UIAlertController(title: "Can't download data from website!", message: "Check internet connection or website adress", preferredStyle: .Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        dataTask?.cancel()
        
        //asynchronious
        dataTask = session.dataTaskWithURL(url) { (data, urlresponse, error) in
            var success = false
            var recipes = [Recipe]()
            if let error = error {
                print(error.description)
                return
            } else if let httpResponse = urlresponse as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let jsonData = self.toJSON(data!) {
                        if let recipesResults = self.parseToRecipes(jsonData) {
                            recipes = recipesResults
                            if !recipes.isEmpty {
                                recipes.sortInPlace({ (first, second) -> Bool in
                                    return first.title < second.title
                                })
                            }
                            success = true
                        }
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if success {
                    print(recipes[0].title)
                    let recipesTableViewController = self.storyboard!.instantiateViewControllerWithIdentifier("RecipesTable") as! RecipesTableViewController
                    recipesTableViewController.recipes = recipes
                    
                    if self.facebookLastName != nil && self.facebookFirstName != nil {
                        recipesTableViewController.userName = self.facebookFirstName! + " " + self.facebookLastName!
                    }
                    self.view.userInteractionEnabled = true
                    self.spinnerIndicator.stopAnimating()
                    self.spinnerIndicator.removeFromSuperview()
                    self.navigationController?.pushViewController(recipesTableViewController, animated: true)
                }
            }
        }
        dataTask?.resume()

    }
    
    private func toJSON(data: NSData) -> AnyObject? {
        do {
        let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            return json
        } catch {
            print("Problem with downloading the data from the Website")
            return nil
        }
    }
    
    private func parseToRecipes(jsonData: AnyObject) -> [Recipe]? {
        if jsonData.isKindOfClass(NSArray) {
            var recipes = [Recipe]()
            let json = jsonData as! NSArray
            for js in json {
                guard let title = js["title"], let description = js["description"], let ingredients = js["ingredients"], let preparing = js["preparing"], let imgs = js["imgs"] else { return nil }
                let images = downloadImagesFromWebsiteAddress(imgs as! [String])
                let pizza = Recipe(title: title as! String, description: description as! String, ingredients: ingredients as! [String], preparing: preparing as! [String], imgs: images)
                recipes.append(pizza)
            }
            return recipes
        } else {
            let pizzaRecipe = Recipe()
            let json = jsonData as! [String: AnyObject]
            guard let pizzaTitle = json["title"], let pizzaDescription = json["description"], let pizzaIngredients = json["ingredients"], let pizzaPreparing = json["preparing"], let imgs = json["imgs"] else { return nil }
            
            let images = downloadImagesFromWebsiteAddress(imgs as! [String])
            pizzaRecipe.title = pizzaTitle as! String
            pizzaRecipe.description = pizzaDescription as! String
            pizzaRecipe.ingredients = pizzaIngredients as! [String]
            pizzaRecipe.preparing = pizzaPreparing as! [String]
            pizzaRecipe.imgs = images
        
            return [pizzaRecipe]
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error == nil && result.token != nil {
            createRightButtonItem()
            readFacebookInformation()
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        navigationItem.rightBarButtonItem = nil
        facebookNavRightButton = nil
        self.facebookFirstName = nil
        self.facebookLastName = nil
        let alert = UIAlertController(title: "Facebook", message: "You're logged out", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //this function is running in background - don't need to use GCD here
    private func downloadImagesFromWebsiteAddress(addresses: [String]) -> [UIImage] {
        var images = [UIImage]()
        for address in addresses {
            let url = NSURL(string: address)!
            let data = NSData(contentsOfURL: url)
            images.append(UIImage(data: data!)!)
        }
        return images
    }
    
    func viewFacebookProfile() {
        let facebookViewController = storyboard?.instantiateViewControllerWithIdentifier("facebook") as! FacebookViewController
        facebookViewController.firstName = self.facebookFirstName!
        facebookViewController.surname = self.facebookLastName!
        facebookViewController.picture = self.facebookImage!
        facebookViewController.gender = self.facebookGender
        facebookViewController.email = self.facebookEmail
        presentViewController(facebookViewController, animated: true, completion: nil)
    }
    
}

