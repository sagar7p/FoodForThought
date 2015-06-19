////
////  Recipe.swift
////  Food For Thought
////
////  Created by Sagar Punhani on 6/15/15.
////  Copyright © 2015 Sagar Punhani. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//struct Keys {
//    static let amountKey = "amount"
//    static let itemKey = "item"
//    static let nameKey = "name"
//    static let descriptionKey = "description"
//    static let servingKey = "serving size"
//    static let timeKey = "time"
//    static let imageKey = "imageKey"
//    static let ingredientKey = "ingredients"
//    static let instructionKey = "instructions"
//}
//
//class Ingredient: NSObject, NSCoding {
//    var amount: Double?
//    var item: String?
//    init(amount: Double, item: String) {
//        self.amount = amount
//        self.item = item
//    }
//    
//    override init() {
//        super.init()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        amount = aDecoder.decodeDoubleForKey(Keys.amountKey)
//        item = aDecoder.decodeObjectForKey(Keys.itemKey) as? String
//    }
//    
//    func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encodeDouble(self.amount!, forKey: Keys.amountKey)
//        aCoder.encodeObject(self.item, forKey: Keys.itemKey)
//    }
//    
//    
//    
//}
//
//class Recipe: NSObject, NSCoding {
//    var name: String?
//    
//    var descriptionOfItem: String?
//    
//    var servingSize: Int?
//    
//    var time: Int?
//    
//    var recipeImage: UIImage?
//    
//    var ingredients = [Ingredient]()
//    
//    var instructions = [String]()
//    
//    override init() {
//        super.init()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        self.name = aDecoder.decodeObjectForKey(Keys.nameKey) as? String
//        self.descriptionOfItem = aDecoder.decodeObjectForKey(Keys.descriptionKey) as? String
//        self.servingSize = aDecoder.decodeIntegerForKey(Keys.servingKey)
//        self.time = aDecoder.decodeIntegerForKey(Keys.timeKey)
//        self.recipeImage = aDecoder.decodeObjectForKey(Keys.imageKey) as? UIImage
//        self.ingredients = (aDecoder.decodeObjectForKey(Keys.ingredientKey) as? [Ingredient])!
//        self.instructions = aDecoder.decodeObjectForKey(Keys.instructionKey) as! [String]
//    }
//    
//    func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encodeObject(self.name, forKey: Keys.nameKey)
//        aCoder.encodeObject(self.descriptionOfItem, forKey: Keys.descriptionKey)
//        aCoder.encodeInteger(self.servingSize!, forKey: Keys.servingKey)
//        aCoder.encodeInteger(self.time!, forKey: Keys.timeKey)
//        aCoder.encodeObject(UIImageJPEGRepresentation(self.recipeImage!, 1.0), forKey: Keys.imageKey)
//        aCoder.encodeObject(self.ingredients, forKey: Keys.ingredientKey)
//        aCoder.encodeObject(self.instructions, forKey: Keys.instructionKey)
//        
//    }
//}
