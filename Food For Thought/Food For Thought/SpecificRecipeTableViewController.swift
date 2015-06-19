//
//  SpecificRecipeTableViewController.swift
//  Food For Thought
//
//  Created by Sagar Punhani on 6/15/15.
//  Copyright © 2015 Sagar Punhani. All rights reserved.
//

import UIKit
import Parse

class SpecificRecipeTableViewController: UITableViewController {
    
    var recipe: PFObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageData = recipe!["recipeImage"] as? PFFile {
            imageData.getDataInBackgroundWithBlock({ (data, error) -> Void in
                if (error == nil) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.updateUI(data!)
                    })
                }
            })
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            let ingredients = recipe!["ingredients"] as! [PFObject]
            return ingredients.count
        default:
            let instructions = recipe!["instructions"] as! [String]
            return instructions.count
        }

    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("ingredient", forIndexPath: indexPath) as! IngredientTableViewCell
            if let cellIngredients = recipe!["ingredients"] as? [PFObject] {
                let ingredientData = cellIngredients[indexPath.row]
                ingredientData.fetchIfNeededInBackgroundWithBlock({ (object, error) -> Void in
                    if error == nil {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            cell.ingredient = object!
                        })
                    }
                })
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("instruction", forIndexPath: indexPath) as! InstructionsTableViewCell
            let cellInstructions = recipe!["instructions"] as! [String]
            cell.setOfInstructions = cellInstructions[indexPath.row]
            cell.row = indexPath.row + 1
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell

        }
        

        // Configure the cell...

    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Ingredients"
        case 1: return "Instructions"
        default: return nil
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? IngredientTableViewCell {
            if cell.plusView.image == UIImage(named: "blue") {
                cell.plusView.image = UIImage(named: "black")
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                cell.plusView.image = UIImage(named: "blue")
            }
        }
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? InstructionsTableViewCell {
            if indexPath.row == 0 {
                if cell.accessoryType == UITableViewCellAccessoryType.None {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }
                else {
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            }
            else {
                if let previousCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)) {
                    if previousCell.accessoryType == UITableViewCellAccessoryType.Checkmark && cell.accessoryType == UITableViewCellAccessoryType.None {
                        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryType.None
                    }
                }
            }
            tableView.reloadData()
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateUI(data: NSData) {
        //image
        let recipeImage = UIImage(data: data)
        let aspectRatio = recipeImage!.size.height/recipeImage!.size.width
        let frame = CGRect(origin: CGPointZero, size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.width * aspectRatio))
        let imageView = UIImageView(frame: frame)
        imageView.image = recipeImage
        
        
        //view for details
        let origin = CGPoint(x: 0, y: self.view.bounds.size.width * aspectRatio)
        let origin1 = CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.width * aspectRatio)
        let size = CGSize(width: self.view.bounds.size.width/2, height: 40)
        let timeFrame = CGRect(origin: origin, size: size)
        let serveFrame = CGRect(origin: origin1, size: size)
        let timeView = UIView(frame: timeFrame)
        timeView.backgroundColor = UIColor.orangeColor()
        let serveView = UIView(frame: serveFrame)
        serveView.backgroundColor = UIColor.greenColor()
        
        //labels
        let timeLabel = UILabel(frame: timeView.bounds)
        timeLabel.textAlignment = NSTextAlignment.Center
        let time = recipe!["time"] as! String
        timeLabel.text = "\(time)"
        timeView.addSubview(timeLabel)
        
        let serveLabel = UILabel(frame: serveView.bounds)
        serveLabel.textAlignment = NSTextAlignment.Center
        let serve = recipe!["servingSize"] as! Int
        serveLabel.text = "\(serve) Serving Size"
        serveView.addSubview(serveLabel)
        
        
        //headerView
        let headerView = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: imageView.bounds.size.width, height: imageView.bounds.size.height + timeView.bounds.size.height)))
        headerView.addSubview(imageView)
        headerView.addSubview(timeView)
        headerView.addSubview(serveView)
        self.tableView.tableHeaderView = headerView
        
        //cells
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableViewAutomaticDimension
        tableView.reloadData()
    }

}
