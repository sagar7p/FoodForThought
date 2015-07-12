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

class AddRecipeTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    var sender: UIViewController?
    var recipe = PFObject(className: "Recipe")
    var ingredientTable = [PFObject(className: "Ingredient")]
    var editingRecipe = false
    var cleared = false
    var instructionTable: [String] {
        get {
           return NSUserDefaults.standardUserDefaults().objectForKey(Keys.userDefaultsKey) as? [String] ?? [""]
        }
    }
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        if !editingRecipe {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(Keys.userDefaultsKey)
        }
        updateUI()
    }
    
    override func viewWillDisappear(animated: Bool) {
        recipe = PFObject(className: "Recipe")
        tableView.reloadData()
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
        return 7
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 5:
            return ingredientTable.count
        case 6:
            return instructionTable.count
        default: return 1
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("name", forIndexPath: indexPath) as! NameTableViewCell
            cell.cleared = cleared
            cell.recipe = self.recipe
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("description", forIndexPath: indexPath) as! DescriptionTableViewCell
            cell.recipe = self.recipe
            cell.cleared = cleared
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("image", forIndexPath: indexPath) as! ImageTableViewCell
            cell.recipe = self.recipe
            cell.foodImage = self.image
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("serving", forIndexPath: indexPath) as! ServingTableViewCell
            cell.recipe = self.recipe
            cell.cleared = cleared
            return cell
        case 4:
            let cell = tableView.dequeueReusableCellWithIdentifier("time", forIndexPath: indexPath) as! TimeTableViewCell
            cell.recipe = self.recipe
            cell.cleared = cleared
            return cell
        case 5:
            let cell = tableView.dequeueReusableCellWithIdentifier("ingredients", forIndexPath: indexPath) as! IngredientsTableViewCell
            cell.ingredient = ingredientTable[indexPath.row]
            cell.cleared = cleared
            return cell
        case 6:
            let cell = tableView.dequeueReusableCellWithIdentifier("instructions", forIndexPath: indexPath) as! InstructionTableViewCell
            cell.row = indexPath.row + 1
            cell.instruction = instructionTable[indexPath.row]
            cell.instructionLabel.delegate = self
            return cell
        default:
            return UITableViewCell()
        
        }
        

        // Configure the cell...

    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Name of Dish"
        case 1:
            return "Details of the Dish"
        case 2:
            return "Image of the Dish"
        case 3:
            return "Serves How Many People"
        case 4:
            return "Time to Cook"
        case 5:
            return "Ingredients"
        default:
            return "Instructions"
        }
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.section == 5 || indexPath.section == 6 {
            return true
        }
        else {
            return false
        }
    }
    
   override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        switch indexPath.section {
        case 5:
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
            if indexPath.section == 5 {
                ingredientTable.removeAtIndex(indexPath.row)
            }
            else {
                let defaults = NSUserDefaults.standardUserDefaults()
                var listOfInstructions = defaults.objectForKey(Keys.userDefaultsKey) as! [String]
                listOfInstructions.removeAtIndex(indexPath.row)
                defaults.setObject(listOfInstructions, forKey: Keys.userDefaultsKey)
                
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            if indexPath.section == 5 {
                ingredientTable.append(PFObject(className: "Ingredient"))
            }
            else {
                let defaults = NSUserDefaults.standardUserDefaults()
                var listOfInstructions = defaults.objectForKey(Keys.userDefaultsKey) as? [String]
                if listOfInstructions != nil {
                    listOfInstructions!.append("")
                }
                else {
                    listOfInstructions = instructionTable + [""]
                }
                defaults.setObject(listOfInstructions, forKey: Keys.userDefaultsKey)
                
            }
            let newPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
            tableView.insertRowsAtIndexPaths([newPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 2 {
            if let foodImage = self.image {
                if foodImage == UIImage(named: "camera") {
                    return 44
                }
                return (self.view.bounds.size.width - 20) * foodImage.size.height/(foodImage.size.width)
            }
            else {
                return 44
            }
        }
        else if indexPath.section == 5 || indexPath.section == 6 {
            return UITableViewAutomaticDimension
        }
        else {
            return 44
        }

    }
    
    //Camera
    @IBAction func takePhoto(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.mediaTypes = [kUTTypeImage as String]

        let alert = UIAlertController(title: "Pick a Location", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction! ) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                picker.sourceType = .Camera
            }
            else {
                picker.sourceType = .PhotoLibrary
            }
            self.presentViewController(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) -> Void in
            picker.sourceType = .PhotoLibrary
            self.presentViewController(picker, animated: true, completion: nil)
        }))
        
        alert.modalPresentationStyle = .Popover
        presentViewController(alert, animated: true, completion: nil)

        
        
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
            defaults.setObject(listOfInstructions, forKey: Keys.userDefaultsKey)
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
        //title
        title = "Make New Recipe"
        
        //change fonts
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Snell Roundhand", size: 25)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        //check whether in editing phase or not
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        if editingRecipe {
            title = "Editing Recipe"
        }
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if editingRecipe {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "dismiss")
        }
        else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .Plain, target: self, action: "clear")
        }
        
        //create footer view
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
    
    //save recipes
    func save() {
        if (recipe["name"] == nil || recipe["description"] == nil || recipe["recipeImage"] != nil || recipe["servingSize"] != nil || recipe["time"] != nil || recipe["ingredients"] != nil || recipe["instructions"] != nil) && !editingRecipe  {
                let alert = UIAlertController(title: "Error", message: "Please fill in all the blanks", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) -> Void in
                    //do nothing
                }))
                presentViewController(alert, animated: true, completion: nil)
        }
        else {
            recipe["user"] = PFUser.currentUser()
            recipe["ingredients"] = ingredientTable
            recipe["instructions"] = instructionTable
            recipe.saveInBackground()
            NSUserDefaults.standardUserDefaults().removeObjectForKey(Keys.userDefaultsKey)
            tableView.reloadData()
            if editingRecipe {
                if let srtvc = sender as? SpecificRecipeTableViewController {
                    srtvc.recipe = recipe
                }
                presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
            recipe = PFObject(className: "Recipe")

        }
    }
    
    func dismiss() {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func clear() {
        cleared = true
        self.ingredientTable = [PFObject(className: "Ingredient")]
        NSUserDefaults.standardUserDefaults().removeObjectForKey(Keys.userDefaultsKey)
        tableView.reloadData()
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.cleared = false
            self.image = UIImage(named: "camera")
            self.recipe = PFObject(className: "Recipe")

        }
        
    }
    
    func textViewDidChange(textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}
