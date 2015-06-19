////
////  NameTableViewCell.swift
////  Food For Thought
////
////  Created by Sagar Punhani on 6/17/15.
////  Copyright © 2015 Sagar Punhani. All rights reserved.
////
//
//import UIKit
//import Parse
//import MobileCoreServices
//
//class NameTableViewCell: UITableViewCell, UITextFieldDelegate {
//    //var recipe: PFObject?
//    @IBOutlet weak var nameLabel: UITextField! {
//        didSet {
//            nameLabel.becomeFirstResponder()
//            nameLabel.delegate = self
//        }
//    }
//    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        //recipe!["name"] = nameLabel.text
//        nameLabel.resignFirstResponder()
//        return true
//    }
//    
//    
//}
//
//class DescriptionTableViewCell: UITableViewCell, UITextFieldDelegate {
//    //var recipe: PFObject?
//    @IBOutlet weak var descriptionLabel: UITextField! {
//        didSet {
//            descriptionLabel.delegate = self
//        }
//    }
//    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        //recipe!["description"] = descriptionLabel.text
//        descriptionLabel.resignFirstResponder()
//        return true
//    }
//    
//}
//
//class ImageTableViewCell: UITableViewCell {
//    //var recipe: PFObject?
//    
//    @IBOutlet weak var itemImageView: UIImageView!
//    
//    /*var foodImage: UIImage? {
//    get {
//    return itemImageView.image
//    }
//    set {
//    itemImageView.image = newValue
//    if let image = newValue {
//    let imageData = UIImageJPEGRepresentation(image, 1.0)
//    let imageFile: PFFile = PFFile(data: imageData!)
//    recipe!["recipeImage"] = imageFile
//    }
//    }
//    }*/
//    
//    
//}
//
//class ServingTableViewCell: UITableViewCell {
//    
//    /*var recipe: PFObject? {
//    didSet {
//    updateRecipe()
//    }
//    }*/
//    
//    @IBOutlet weak var numberOfPeopleLabel: UILabel!
//    
//    @IBAction func addServing(sender: UIStepper) {
//        sender.wraps = true
//        sender.autorepeat = true
//        sender.maximumValue = 15
//        numberOfPeopleLabel.text = Int(sender.value).description
//        //updateRecipe()
//    }
//    
//    /*func updateRecipe() {
//    if let serving = NSNumberFormatter().numberFromString(numberOfPeopleLabel.text!)?.integerValue {
//    recipe!["servingSize"] = serving
//    }
//    }*/
//    
//    
//}
//
//class TimeTableViewCell: UITableViewCell {
//    /*var recipe: PFObject? {
//    didSet {
//    updateRecipe()
//    }
//    }*/
//    var timeLength = "min"
//    @IBOutlet weak var timeLabel: UILabel!
//    var timeUnit = true
//    
//    @IBOutlet weak var stepper: UIStepper!
//    
//    @IBAction func timeChange(sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex {
//        case 0:
//            timeLength = "min"
//            timeUnit = true
//            timeLabel.text = "0"
//            stepper.value = 0
//        default:
//            timeLength = "Hr"
//            timeUnit = false
//            timeLabel.text = "0"
//            stepper.value = 0
//        }
//    }
//    
//    @IBAction func makeTimeChange(sender: UIStepper) {
//        sender.wraps = true
//        sender.autorepeat = true
//        if timeUnit {
//            sender.maximumValue = 12
//            timeLabel.text = (Int(sender.value) * 5).description
//        }else {
//            sender.maximumValue = 4
//            timeLabel.text = Int(sender.value).description
//        }
//        //updateRecipe()
//        
//    }
//    
//    /*func updateRecipe() {
//    recipe!["time"] = "\(timeLabel.text!) \(timeLength)"
//    }*/
//    
//}
//
//class IngredientsTableViewCell: UITableViewCell, UITextFieldDelegate {
//    //var recipe: PFObject?
//    var ingredient = PFObject(className: "Ingredient")
//    
//    @IBOutlet weak var itemLabel: UITextField! {
//        didSet {
//            itemLabel.delegate = self
//        }
//    }
//    @IBOutlet weak var amountLabel: UILabel!
//    
//    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
//        updateIngredient()
//        return true
//    }
//    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        itemLabel.resignFirstResponder()
//        updateIngredient()
//        //updateRecipe()
//        return true
//    }
//    
//    @IBAction func amountStepper(sender: UIStepper) {
//        var values = ["0","¼","½","¾","1","1¼","1½","1¾","2","2¼","2½","2¾","3","4","5","6","7","8","9","10"]
//        sender.wraps = true
//        sender.autorepeat = true
//        sender.maximumValue = Double(values.count)
//        amountLabel.text = values[Int(sender.value)]
//        updateIngredient()
//        
//    }
//    
//    func updateIngredient() {
//        ingredient["amount"] = amountLabel.text
//        ingredient["item"] = itemLabel.text
//    }
//    
//    /*func updateRecipe() {
//    print("updated")
//    var allIngredients = recipe!["ingredients"] as? [PFObject]
//    
//    if allIngredients != nil {
//    allIngredients!.append(ingredient)
//    recipe!["ingredients"] = allIngredients
//    }
//    else {
//    recipe!["ingredients"] = [ingredient]
//    }
//    }*/
//    
//}
//
//class InstructionTableViewCell: UITableViewCell, UITextViewDelegate {
//    var recipe: PFObject?
//    var row: Int? {
//        didSet {
//            updateUI()
//        }
//    }
//    
//    @IBOutlet weak var instructionNumber: UILabel!
//    @IBOutlet weak var stepNumberLabel: UILabel!
//    @IBOutlet weak var instructionLabel: UITextView! {
//        didSet {
//            instructionLabel.delegate = self
//        }
//    }
//    
//    func updateUI() {
//        if let currentRow = row {
//            let attributedString = NSMutableAttributedString(string: "\(currentRow).", attributes: [NSFontAttributeName : UIFont.boldSystemFontOfSize(20)])
//            instructionNumber.attributedText = attributedString
//        }
//    }
//    
//    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            textView.resignFirstResponder()
//            var allInstructions = recipe!["instructions"] as? [String]
//            if allInstructions != nil {
//                allInstructions!.append(textView.text)
//                recipe!["instructions"] = allInstructions
//            }
//            else {
//                recipe!["instructions"] = [textView.text!]
//            }
//            return false
//        }
//        return true
//    }
//    
//    
//}
//
