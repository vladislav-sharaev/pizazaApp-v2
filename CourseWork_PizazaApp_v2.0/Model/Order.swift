//
//  Order.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 10/6/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation

class Order {
    var address: String
    var date: String
    var onDate: String
    var code: String?
    var finalCost: Double
    var floor: String?
    var name: String
    var porch: String?
    var room: String?
    var telephone: String
    var food = [BasketElement]()
    
    init(address: String, date: String, onDate: String, code: String?, finalCost: Double, floor: String?, name: String, porch: String?, room: String?, telephone: String) {
        self.address = address
        self.date = date
        self.onDate = onDate
        self.code = code
        self.finalCost = finalCost
        self.floor = floor
        self.name = name
        self.porch = porch
        self.room = room
        self.telephone = telephone
    }
}
