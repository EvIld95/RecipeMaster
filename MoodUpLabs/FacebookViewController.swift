//
//  FacebookViewController.swift
//  MoodUpLabs
//
//  Created by Pawel Szudrowicz on 30.04.2016.
//  Copyright © 2016 Pawel Szudrowicz. All rights reserved.
//

import UIKit
import UIKit


class FacebookViewController: UIViewController {
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    
    var picture: UIImage!
    var firstName: String!
    var email: String?
    var surname: String!
    var gender: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.text = "Hello, \(firstName)"
        pictureImageView.image = picture
        emailLabel.text = email ?? "No info"
        genderLabel.text = gender ?? "No info"
        surnameLabel.text = surname
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
