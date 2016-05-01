//
//  RecipeTableViewCell.swift
//  MoodUpLabs
//
//  Created by Pawel Szudrowicz on 28.04.2016.
//  Copyright © 2016 Pawel Szudrowicz. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
