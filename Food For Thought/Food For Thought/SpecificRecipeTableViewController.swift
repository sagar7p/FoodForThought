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
    
    //current recipe
    var recipe: PFObject? {
        didSet {
            updateUI()
        }
    }
    //showing details
    var detailOpenend = false
    
    //color
    var color: UIColor? {
        return self.navigationController?.navigationBar.barTintColor
    }


    override func viewDidLoad() {
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

    //load cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var bgcolor: UIColor {
            if indexPath.row % 2 == 0 {
                return UIColor(red: 240/255, green: 240/255, blue: 250/255, alpha: 1.0)
            }
            return UIColor.whiteColor()
        }
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
            cell.backgroundColor = bgcolor
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("instruction", forIndexPath: indexPath) as! InstructionsTableViewCell
            let cellInstructions = recipe!["instructions"] as! [String]
            cell.setOfInstructions = cellInstructions[indexPath.row]
            cell.row = indexPath.row + 1
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.backgroundColor = bgcolor
            return cell

        }
        

        // Configure the cell...

    }
    
    /*override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Ingredients"
        case 1: return "Instructions"
        default: return nil
        }
    }*/
    
    //check marks for ingredients and instructions
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
    //section view
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.bounds.width, height: 50)))
        sectionView.backgroundColor = UIColor.whiteColor()
        let sectionTitle = UILabel(frame: sectionView.bounds)
        
        switch section {
        case 0: sectionTitle.text = "Ingredients"
        default: sectionTitle.text = "Instructions"
        }
        sectionTitle.textColor = UIColor.blueColor()
        sectionTitle.font = UIFont(name: "Snell Roundhand", size: 25)
        sectionTitle.textAlignment = .Center
        sectionView.addSubview(sectionTitle)
        sectionView.layer.borderColor = self.color?.CGColor
        sectionView.layer.borderWidth = 1
        
        return sectionView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Edit Recipe" {
            if let nvc = segue.destinationViewController as? UINavigationController {
                if let rtvc = nvc.visibleViewController as? AddRecipeTableViewController {
                    rtvc.recipe = recipe!
                    rtvc.editingRecipe = true
                    rtvc.ingredientTable = recipe!["ingredients"] as! [PFObject]
                    rtvc.sender = self
                    NSUserDefaults.standardUserDefaults().setObject(recipe!["instructions"
                        ] as! [String], forKey: Keys.userDefaultsKey)
                }
            }
        }
    }
    
    //update all the stuff
    func updateUI() {
        title = recipe!["name"] as? String
        if let imageData = recipe!["recipeImage"] as? PFFile {
            imageData.getDataInBackgroundWithBlock({ (data, error) -> Void in
                if (error == nil) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.updateUI(data!)
                    })
                }
            })
        }
    }

    
    func updateUI(data: NSData) {
        
        //Edit Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit",style: .Plain, target: self, action: "editRecipe")
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        //change fonts
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Snell Roundhand", size: 25)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]

        
        //image
        let recipeImage = UIImage(data: data)
        let aspectRatio = recipeImage!.size.height/recipeImage!.size.width
        let frame = CGRect(origin: CGPointZero, size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.width * aspectRatio))
        let imageView = UIButton(frame: frame)
        imageView.setImage(recipeImage, forState: .Normal)
        imageView.addTarget(self, action: "showDetails:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        //view for details
        let origin = CGPoint(x: 0, y: self.view.bounds.size.width * aspectRatio)
        let origin1 = CGPoint(x: self.view.bounds.size.width/3, y: self.view.bounds.size.width * aspectRatio)
        let origin2 = CGPoint(x: 2 * self.view.bounds.size.width/3, y: self.view.bounds.size.width * aspectRatio)
        let size = CGSize(width: self.view.bounds.size.width/3, height: 100)
        let timeFrame = CGRect(origin: origin, size: size)
        let serveFrame = CGRect(origin: origin1, size: size)
        let numberFrame = CGRect(origin: origin2, size: size)
        
        
        let timeCircle = UIView(frame: timeFrame)
        timeCircle.bounds.size = CGSize(width: 80, height: 80)
        timeCircle.backgroundColor = UIColor.whiteColor()
        timeCircle.clipsToBounds = true
        timeCircle.layer.cornerRadius = timeCircle.bounds.size.width/2
        timeCircle.layer.borderWidth = 1
        timeCircle.layer.borderColor = color?.CGColor
        
        let serveCircle = UIView(frame: serveFrame)
        serveCircle.bounds.size = CGSize(width: 80, height: 80)
        serveCircle.backgroundColor = UIColor.whiteColor()
        serveCircle.clipsToBounds = true
        serveCircle.layer.cornerRadius = timeCircle.bounds.size.width/2
        serveCircle.layer.borderWidth = 1
        serveCircle.layer.borderColor = color?.CGColor
        
        let numberCircle = UIView(frame: numberFrame)
        numberCircle.bounds.size = CGSize(width: 80, height: 80)
        numberCircle.backgroundColor = UIColor.whiteColor()
        numberCircle.clipsToBounds = true
        numberCircle.layer.cornerRadius = timeCircle.bounds.size.width/2
        numberCircle.layer.borderWidth = 1
        numberCircle.layer.borderColor = color?.CGColor
        
        
        //labels
        let timeLabel = UILabel(frame: timeCircle.bounds)
        timeLabel.textAlignment = NSTextAlignment.Center
        timeLabel.textColor = color
        let time = recipe!["time"] as! String
        timeLabel.text = "\(time)"
        timeCircle.addSubview(timeLabel)
        
        let serveLabel = UILabel(frame: serveCircle.bounds)
        serveLabel.numberOfLines = 0
        serveLabel.textColor = color
        serveLabel.textAlignment = NSTextAlignment.Center
        let serve = recipe!["servingSize"] as! Int
        serveLabel.text = "Serves\n\(serve)"
        serveCircle.addSubview(serveLabel)
        
        let numberLabel = UILabel(frame: numberCircle.bounds)
        numberLabel.numberOfLines = 0
        numberLabel.textColor = color
        numberLabel.textAlignment = NSTextAlignment.Center
        let number = recipe!["ingredients"] as! [PFObject]
        numberLabel.text = "\(number.count)\nItems"
        numberCircle.addSubview(numberLabel)
        
        
        //headerView
        let headerView = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: imageView.bounds.size.width, height: imageView.bounds.size.height + timeFrame.height)))
        headerView.addSubview(imageView)
        headerView.addSubview(serveCircle)
        headerView.addSubview(timeCircle)
        headerView.addSubview(numberCircle)
        self.tableView.tableHeaderView = headerView
        
        //cells
        self.tableView.estimatedRowHeight = 120
        tableView.reloadData()
    }
    
    //edit the recipe
    func editRecipe() {
        performSegueWithIdentifier("Edit Recipe", sender: self)
        
    }
    
    //show description label
    func showDetails(sender: UIButton) {
        if detailOpenend  == false {
            detailOpenend = true

            let backButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: sender.bounds.size.width, height: sender.bounds.size.height/4)))
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
            let detailText = UILabel(frame: backButton.frame)
            detailText.numberOfLines = 0
            detailText.minimumScaleFactor = 12
            detailText.textAlignment = .Center
            let description = recipe!["description"] as! String
            detailText.text = description
            backButton.addSubview(detailText)
            visualEffectView.frame = backButton.frame
            visualEffectView.addSubview(backButton)
            visualEffectView.center.y = 0 - visualEffectView.bounds.size.height/2
            backButton.addTarget(self, action: "deselect:", forControlEvents: UIControlEvents.TouchUpInside)
            sender.addSubview(visualEffectView)
            backButton.backgroundColor = UIColor.clearColor()
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                visualEffectView.center.y = sender.bounds.midY - sender.bounds.size.height/2 + backButton.bounds.size.height/2
                }, completion: nil)
        }

    }
    
    //get rid of description
    func deselect(sender: UIButton) {
        detailOpenend = false
        let superView = sender.superview
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
            superView!.center.y = -sender.bounds.size.height/2

            }) { (bool) -> Void in
                superView?.removeFromSuperview()

        }
        
        
    }

}
