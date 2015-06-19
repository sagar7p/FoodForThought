//
//  IngredientTableViewCell.swift
//  Food For Thought
//
//  Created by Sagar Punhani on 6/15/15.
//  Copyright © 2015 Sagar Punhani. All rights reserved.
//

import UIKit
import Parse

class IngredientTableViewCell: UITableViewCell {
    
    var ingredient: PFObject? {
        didSet {
            updateUI()
        }
    }

    @IBOutlet weak var plusView: UIImageView!
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var ingredientDescriptionLabel: UILabel!
    
    func updateUI() {
        
        if let amount = ingredient!["amount"] as? String {
            if let description = ingredient!["item"] as? String {
                let newamount = NSMutableAttributedString(string: "\(amount)", attributes: [NSFontAttributeName : UIFont.boldSystemFontOfSize(25)])
                ingredientLabel.attributedText = newamount
                ingredientDescriptionLabel.text = description
            }
        }
    }
}
