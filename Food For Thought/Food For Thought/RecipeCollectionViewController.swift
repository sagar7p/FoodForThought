//
//  RecipeCollectionViewController.swift
//  Food For Thought
//
//  Created by Sagar Punhani on 6/15/15.
//  Copyright © 2015 Sagar Punhani. All rights reserved.
//

import UIKit
import Parse

private let reuseIdentifier = "Cell"

class RecipeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var allRecipes: [PFObject] = [] {
        willSet {
            if allRecipes.count != newValue.count {
                collectionView!.reloadData()
            }
        }
    }
    
    var currentRecipe = PFObject(className: "Recipe")

    override func viewDidLoad() {
        
        super.viewDidLoad()
        /*let user = PFUser.currentUser()
        let query = PFQuery(className: "Recipe")
        query.whereKey("user", equalTo: user!)
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.allRecipes = objects! as! [PFObject]
                })
            }
        })*/
        
        /*let test1Recipe = PFObject(className: "Recipe")
        let test2Recipe = PFObject(className: "Recipe")
        test1Recipe["name"] = "Ravioli"
        test1Recipe["time"] = "30 min"
        test1Recipe["servingSize"] = 2
        let imageData = UIImageJPEGRepresentation(UIImage(named: "test1")!, 1.0)
        let imageFile: PFFile = PFFile(data: imageData!)
        test1Recipe["recipeImage"] = imageFile
        let ingredient1 = PFObject(className: "Ingredient")
        ingredient1["amount"] = "5"
        ingredient1["item"] = "Eggs"
        let ingredient2 = PFObject(className: "Ingredient")
        ingredient2["amount"] = "6¼"
        ingredient2["item"] = "cheeses"
        test1Recipe["ingredients"] = [ingredient1,ingredient2]
        test1Recipe["instructions"] = ["Put in oven and be a god aabout it for like 15 min", "Once done make sure you let it cool for 40 hours nad also ahve some fun make sure all the pan is moistured do not let bugs in ravioli is so fun to make", "I really don't know what else to say except this is awesome make sure you server fore 10,000 people this is going to be great OMG"]
        test1Recipe["user"] = user!
        test2Recipe["name"] = "Pasta"
        test2Recipe["time"] = "40 min"
        test2Recipe["servingSize"] = 1
        let imageData2 =  UIImageJPEGRepresentation(UIImage(named: "test2")!, 1.0)
        let imageFile2 = PFFile(data: imageData2!)
        test2Recipe["recipeImage"] = imageFile2
        test2Recipe["ingredients"] = [ingredient1, ingredient2]
        test2Recipe["instructions"] = ["OMG this is so hot please make all electrical equipment are off and no is burning to death","Placing in boiling water for about 10 minutes and let cool so you dont destroy everything","This is really hot someone save me I can't do this anymore","This is really hot someone save me I can't do this anymore"]
        test2Recipe["user"] = user!
        allRecipes.append(test1Recipe)
        allRecipes.append(test2Recipe)
        test1Recipe.saveInBackground()
        test2Recipe.saveInBackground()*/
        
        //if you have more UIViews on screen, use insertSubview:belowSubview: to place it underneath the lowest view


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let user = PFUser.currentUser()
        let query = PFQuery(className: "Recipe")
        query.whereKey("user", equalTo: user!)
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.allRecipes = objects! as! [PFObject]
                })
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "show recipe" {
            if let twc = segue.destinationViewController as? SpecificRecipeTableViewController {
                twc.recipe = currentRecipe
            }
        }
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return allRecipes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Recipe", forIndexPath: indexPath) as! RecipeCollectionViewCell
        
        cell.recipe = self.allRecipes[indexPath.row]
        
        // Configure the cell
    
        return cell
    }
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        currentRecipe = allRecipes[indexPath.row]
        performSegueWithIdentifier("show recipe", sender: collectionView)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenWidth = view.bounds.size.width
        return CGSize(width: screenWidth/2.5, height: screenWidth/2.5)
    }

}
