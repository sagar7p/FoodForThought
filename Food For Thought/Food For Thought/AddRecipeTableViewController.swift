//
//  AddRecipeTableViewController.swift
//  Food For Thought
//
//  Created by Sagar Punhani on 6/17/15.
//  Copyright © 2015 Sagar Punhani. All rights reserved.
//

import UIKit
import Parse
import MobileCoreServices

struct Keys {
    static let userDefaultsKey = "Key"
}

class AddRecipeTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var recipe = PFObject(className: "Recipe")
    var ingredientTable = [PFObject(className: "Ingredient")]
    var instructionTable: [String] {
        get {
           return NSUserDefaults.standardUserDefaults().objectForKey(Keys.userDefaultsKey) as? [String] ?? [""]
        }
    }
    var image: UIImage?

    override func viewDidLoad() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(Keys.userDefaultsKey)
        super.viewDidLoad()
        updateUI()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.reloadData()
        if(editing) {
            tapGesture.enabled = false
        }
        else {
            tapGesture.enabled = true
        }
    }
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    @IBAction func exitKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        case 2:
            return ingredientTable.count
        case 3:
            return instructionTable.count
        default: return 0
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("name", forIndexPath: indexPath) as! NameTableViewCell
            cell.recipe = self.recipe
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("description", forIndexPath: indexPath) as! DescriptionTableViewCell
            cell.recipe = self.recipe
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("image", forIndexPath: indexPath) as! ImageTableViewCell
            cell.recipe = self.recipe
            cell.foodImage = self.image
            return cell
        }
        case 1:
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("serving", forIndexPath: indexPath) as! ServingTableViewCell
            cell.recipe = self.recipe
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("time", forIndexPath: indexPath) as! TimeTableViewCell
            cell.recipe = self.recipe
            return cell
        }
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("ingredients", forIndexPath: indexPath) as! IngredientsTableViewCell
            //cell.recipe = self.recipe
            cell.ingredient = ingredientTable[indexPath.row]
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("instructions", forIndexPath: indexPath) as! InstructionTableViewCell
            cell.recipe = self.recipe
            cell.row = indexPath.row + 1
            return cell
        default:
            return UITableViewCell()
        
        }
        

        // Configure the cell...

    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Dish Details"
        case 1:
            return "Preparation Details"
        case 2:
            return "Ingredients"
        default:
            return "Instructions"
        }
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.section == 2 || indexPath.section == 3 {
            return true
        }
        else {
            return false
        }
    }
    
   override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        switch indexPath.section {
        case 2:
            if indexPath.row == ingredientTable.count - 1 {
                return .Insert
            }
            else {
                return .Delete
            }
        default:
            if indexPath.row == instructionTable.count - 1 {
                return .Insert
            }
            else {
                return .Delete
            }
        }
    
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            if indexPath.section == 2 {
                ingredientTable.removeAtIndex(indexPath.row)
            }
            else {
                let defaults = NSUserDefaults.standardUserDefaults()
                var listOfInstructions = defaults.objectForKey(Keys.userDefaultsKey) as! [String]
                listOfInstructions.removeAtIndex(indexPath.row)
                defaults.setObject(listOfInstructions, forKey: Keys.userDefaultsKey)
                
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.reloadData()
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            if indexPath.section == 2 {
                ingredientTable.insert(PFObject(className: "Ingredient"), atIndex: indexPath.row)
            }
            else {
                let defaults = NSUserDefaults.standardUserDefaults()
                var listOfInstructions = defaults.objectForKey(Keys.userDefaultsKey) as? [String]
                if listOfInstructions != nil {
                    listOfInstructions!.insert("Instruction", atIndex: indexPath.row)
                }
                else {
                    listOfInstructions = instructionTable + ["Instruction"]
                }
                defaults.setObject(listOfInstructions, forKey: Keys.userDefaultsKey)
                
            }
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.reloadData()
        }    
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 0 && indexPath.row != 2) || indexPath.section == 1 {
            return 44
        }
        else if (indexPath.section == 0 && indexPath.row == 2) {
            if let foodImage = self.image {
                return (self.view.bounds.size.width - 20) * foodImage.size.height/(foodImage.size.width)
            }
            else {
                return 44
            }
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    //Camera
    @IBAction func takePhoto(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.mediaTypes = [kUTTypeImage as String]
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            picker.sourceType = .Camera
        }
        else {
            picker.sourceType = .PhotoLibrary
        }
        presentViewController(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image = image
            tableView.reloadData()
        }
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    

    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let defaults = NSUserDefaults.standardUserDefaults()
        var listOfInstructions = defaults.objectForKey(Keys.userDefaultsKey) as? [String]
        if listOfInstructions != nil {
            swap(&listOfInstructions![fromIndexPath.row], &listOfInstructions![toIndexPath.row])
            /*var itemToMove = listOfInstructions![fromIndexPath.row]
            listOfInstructions!.removeAtIndex(fromIndexPath.row)
            listOfInstructions!.insert(itemToMove, atIndex: toIndexPath.row)*/
            defaults.setObject(listOfInstructions, forKey: Keys.userDefaultsKey)
            print(defaults.objectForKey(Keys.userDefaultsKey))
            //tableView.reloadData()
        }

    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        if indexPath.section == 3 {
            return true
        }
        else {
            return false
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateUI() {
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let viewFrame = UIView()
        viewFrame.center = CGPoint(x: self.view.center.x, y: self.view.bounds.size.height - 30)
        viewFrame.bounds.size = CGSize(width: self.view.bounds.width, height: 60)
        let origin = CGPoint(x: self.view.bounds.width * 0.1, y: 10)
        let saveButton = UIButton(frame: CGRect(origin: origin, size: CGSize(width: self.view.bounds.width * 0.8, height: 30)))
        saveButton.backgroundColor = UIColor.blueColor()
        saveButton.setTitle("Save", forState: UIControlState.Normal)
        saveButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        saveButton.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        viewFrame.addSubview(saveButton)
        tableView.tableFooterView = viewFrame
        
        
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension
        tableView.reloadData()
    }
    
    func save() {
        recipe["user"] = PFUser.currentUser()
        recipe["ingredients"] = ingredientTable
        recipe["instructions"] = instructionTable
        recipe.saveInBackground()
        recipe = PFObject(className: "Recipe")
        tableView.reloadData()
        NSUserDefaults.standardUserDefaults().removeObjectForKey(Keys.userDefaultsKey)
    }

}
