//
//  RecipeCollectionViewCell.swift
//  Food For Thought
//
//  Created by Sagar Punhani on 6/15/15.
//  Copyright © 2015 Sagar Punhani. All rights reserved.
//

import UIKit
import Parse

class RecipeCollectionViewCell: UICollectionViewCell {
    
    var recipe: PFObject? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textLabel: UILabel!
    
    func updateUI() {
        if let imageData = recipe!["recipeImage"] as? PFFile {
            imageData.getDataInBackgroundWithBlock { (data, error) -> Void in
                if error == nil {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.imageView.image = UIImage(data: data!)
                    })
                }
            }
        }
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.size.width/2
        textLabel.backgroundColor = UIColor.orangeColor()
        textLabel.backgroundColor = UIColor.orangeColor()
        textLabel.clipsToBounds = true
        textLabel.layer.cornerRadius = 5
        textLabel.text = recipe!["name"] as? String
    }
    
}
