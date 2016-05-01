//
//  Recipe.swift
//  MoodUpLabs
//
//  Created by Pawel Szudrowicz on 28.04.2016.
//  Copyright © 2016 Pawel Szudrowicz. All rights reserved.
//

import Foundation
import UIKit

class Recipe {
    var title: String
    var description: String
    var ingredients: [String]
    var preparing: [String]
    var imgs: [UIImage]
    init(title: String, description: String, ingredients: [String], preparing: [String], imgs: [UIImage]) {
        self.title = title
        self.description = description
        self.ingredients = ingredients
        self.preparing = preparing
        self.imgs = imgs
    }
    
    init() {
        self.title = ""
        self.description = ""
        self.ingredients = [""]
        self.preparing = [""]
        self.imgs = [UIImage]()
    }
}