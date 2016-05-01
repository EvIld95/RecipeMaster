//
//  RecipesTableViewController.swift
//  MoodUpLabs
//
//  Created by Pawel Szudrowicz on 28.04.2016.
//  Copyright © 2016 Pawel Szudrowicz. All rights reserved.
//

import UIKit

class RecipesTableViewController: UITableViewController {
    
    var recipes: [Recipe]!
    var userName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("recipeCell", forIndexPath: indexPath) as! RecipeTableViewCell
        
        cell.recipeTitle.text = recipes[indexPath.row].title
        cell.recipeImageView.image = recipes[indexPath.row].imgs[0]
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailRecipe" {
            let destinationViewController = segue.destinationViewController as! RecipeDetailViewController
            destinationViewController.selectedRecipe = recipes[tableView.indexPathForSelectedRow!.row]
            if userName != nil {
                destinationViewController.facebookStatusInfo = userName!
            }
        }
    }
    

}
