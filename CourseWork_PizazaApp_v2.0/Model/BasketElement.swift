//
//  BasketElement.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/30/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class BasketElement: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var calories: Double = 0
    @objc dynamic var cost: Double = 0
    @objc dynamic var ingridients: String? = nil
    @objc dynamic var url: String = ""
    //кол-во одинаковых элементов
    @objc dynamic var count: Int = 0
    @objc dynamic var cu: String = ""
    
}
