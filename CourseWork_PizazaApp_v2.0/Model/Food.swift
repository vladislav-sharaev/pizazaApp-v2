//
//  Categorie.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/22/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation

class Food {
    var name: String
    var ingridients: String?
    var url: String
    var maxCalories: Double
    var minCalories: Double?
    var maxCost: Double
    var minCost: Double?
    var cu: String
    
    init(name: String, ingridients: String?, url: String, maxCalories: Double, minCalories: Double?, maxCost: Double, minCost: Double?, cu: String) {
        self.name = name
        self.ingridients = ingridients
        self.url = url
        self.maxCalories = maxCalories
        self.minCalories = minCalories
        self.maxCost = maxCost
        self.minCost = minCost
        self.cu = cu
    }
}
