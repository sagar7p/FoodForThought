//
//  NameTableViewCell.swift
//  Food For Thought
//
//  Created by Sagar Punhani on 6/17/15.
//  Copyright © 2015 Sagar Punhani. All rights reserved.
//

import UIKit
import Parse
import MobileCoreServices

class NameTableViewCell: UITableViewCell, UITextFieldDelegate {
    var cleared = false
    var recipe: PFObject? {
        didSet {
            if let name = recipe!["name"] as? String {
                nameLabel.text = name
            }
            if cleared {
                nameLabel.text = ""
            }
        }
    }
    @IBOutlet weak var nameLabel: UITextField! {
        didSet {
            nameLabel.becomeFirstResponder()
            nameLabel.delegate = self
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        recipe!["name"] = nameLabel.text
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        recipe!["name"] = nameLabel.text
        nameLabel.resignFirstResponder()
        return true
    }


}

class DescriptionTableViewCell: UITableViewCell, UITextFieldDelegate {
    var cleared = false
    var recipe: PFObject? {
        didSet {
            if let description = recipe!["description"] as? String {
                descriptionLabel.text = description
            }
            if cleared {
                descriptionLabel.text = ""
            }
        }
    }
    @IBOutlet weak var descriptionLabel: UITextField! {
        didSet {
            descriptionLabel.delegate = self
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        recipe!["description"] = descriptionLabel.text
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        recipe!["description"] = descriptionLabel.text
        descriptionLabel.resignFirstResponder()
        return true
    }
    
}

class ImageTableViewCell: UITableViewCell {
    var recipe: PFObject? {
        didSet {
            if let imageData = recipe!["recipeImage"] as? PFFile {
                imageData.getDataInBackgroundWithBlock({ (data, error) -> Void in
                    if (error == nil) {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            if self.foodImage == UIImage(named: "camera") {
                                self.foodImage = UIImage(data: data!)
                            }
                        })
                    }
                })
            }
        }
    }
    
    
    @IBOutlet weak var imageItemButton: UIButton!
    
    var foodImage: UIImage? {
        get {
            return imageItemButton.imageView?.image
        }
        set {
            if newValue != nil {
                imageItemButton.setImage(newValue, forState: .Normal)
                if let image = newValue {
                    let imageData = UIImageJPEGRepresentation(image, 1.0)
                    let imageFile: PFFile = PFFile(data: imageData!)
                    recipe!["recipeImage"] = imageFile
                }
            }
        }
    }

    
}

class ServingTableViewCell: UITableViewCell {
    var cleared = false
    var recipe: PFObject? {
        didSet {
            if let serving = recipe!["servingSize"] as? Int {
                numberOfPeopleLabel.text = serving.description
            }
            if cleared {
                 numberOfPeopleLabel.text = "0"
            }
        }
    }
    
    @IBOutlet weak var numberOfPeopleLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    @IBAction func addServing(sender: UIStepper) {
        sender.wraps = true
        sender.autorepeat = true
        sender.maximumValue = 15
        numberOfPeopleLabel.text = Int(sender.value).description
        updateRecipe()
    }
    
    func updateRecipe() {
        if let serving = NSNumberFormatter().numberFromString(numberOfPeopleLabel.text!)?.integerValue {
            recipe!["servingSize"] = serving
        }
    }
    
    
}

class TimeTableViewCell: UITableViewCell {
    var cleared = false
    var recipe: PFObject? {
        didSet {
            if let time = recipe!["time"] as? String {
                timeLabel.text = time
            }
            if cleared {
                timeLabel.text = "0 min"
                stepper.value = 0
            }
        }
    }
    @IBOutlet weak var timeLabel: UILabel!
    var timeUnit = true

    @IBOutlet weak var stepper: UIStepper!
    
    @IBAction func makeTimeChange(sender: UIStepper) {
        let timeTable = ["0 min", "5 min","10 min","15 min","20 min","30 min","40 min", "50 min", "1 hour", "1½ hours","2 hours", "2½ hours", "3 hours","3½ hours","4 hours"]
        sender.wraps = true
        sender.autorepeat = true
        sender.maximumValue = Double(timeTable.count - 1 )
        timeLabel.text = timeTable[Int(sender.value)]
        updateRecipe()
        
    }
    
    func updateRecipe() {
        recipe!["time"] = "\(timeLabel.text!)"
    }
    
}

class IngredientsTableViewCell: UITableViewCell, UITextFieldDelegate {
    var cleared = false
    var ingredient: PFObject? {
        didSet {
            if let amount = ingredient!["amount"] as? String{
                amountLabel.text = amount
            }
            if let item = ingredient!["item"] as? String {
                itemLabel.text = item
            }
            if cleared {
                amountLabel.text = "0"
                itemLabel.text = ""
                stepper.value = 0
            }
        }
    }
    
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var itemLabel: UITextField! {
        didSet {
            itemLabel.delegate = self
        }
    }
    @IBOutlet weak var amountLabel: UILabel!
    
    func textFieldDidEndEditing(textField: UITextField) {
        updateIngredient()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        itemLabel.resignFirstResponder()
        updateIngredient()
        return true
    }
    
    @IBAction func amountStepper(sender: UIStepper) {
        let values = ["0","¼","½","¾","1","1¼","1½","1¾","2","2¼","2½","2¾","3","4","5","6","7","8","9","10"]
        sender.wraps = true
        sender.autorepeat = true
        sender.maximumValue = Double(values.count - 1 )
        amountLabel.text = values[Int(sender.value)]
        updateIngredient()

    }
    
    func updateIngredient() {
        ingredient!["amount"] = amountLabel.text
        ingredient!["item"] = itemLabel.text
    }
    
}

class InstructionTableViewCell: UITableViewCell{
    var instruction: String? {
        didSet {
            if instruction != nil {
                instructionLabel.text = instruction
            }
        }
    }
    var row: Int? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var instructionNumber: UILabel!
    @IBOutlet weak var stepNumberLabel: UILabel!
    @IBOutlet weak var instructionLabel: UITextView! {
        didSet {
            observeTextField()
        }
    }
    
    func updateUI() {
        instructionLabel.layer.cornerRadius = 5
        instructionLabel.layer.borderColor = UIColor(red: 204.0/256.0, green: 204.0/256.0, blue: 204.0/256.0, alpha: 1.0).CGColor
        instructionLabel.layer.borderWidth = 1
        if let currentRow = row {
            let attributedString = NSMutableAttributedString(string: "\(currentRow).", attributes: [NSFontAttributeName : UIFont.boldSystemFontOfSize(20)])
            instructionNumber.attributedText = attributedString
        }
    }
    
    func updateInstruction() {
        if let instructionItem = instructionLabel.text {
            let center = NSUserDefaults.standardUserDefaults()
            var listOfInstructions = center.objectForKey(Keys.userDefaultsKey) as? [String]
            if listOfInstructions != nil {
                if row! - 1 < listOfInstructions!.count {
                    listOfInstructions![row! - 1] = instructionItem
                    center.setObject(listOfInstructions, forKey: Keys.userDefaultsKey)
                }
                else {
                    listOfInstructions!.append(instructionItem)
                    center.setObject(listOfInstructions, forKey: Keys.userDefaultsKey)
                }
            }
            else {
                center.setObject([instructionItem], forKey: (Keys.userDefaultsKey))
            }
            
        }
    }
    
    func observeTextField() {
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        center.addObserverForName(UITextViewTextDidEndEditingNotification, object: instructionLabel, queue: queue) { (notification) -> Void in
            self.updateInstruction()
        }
    }

    
}
