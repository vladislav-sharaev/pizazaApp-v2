//
//  BasketElementStorageCore.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 10/1/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation
import RealmSwift

class BasketElementStorageCore {
    var realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    lazy var basketElements: Results<BasketElement> = realm.objects(BasketElement.self)
    
    func getBasketElement(name: String) -> BasketElement? {
        return basketElements.first { $0.name == name }
    }
    
    func getBasketElements() -> [BasketElement] {
        return Array(basketElements)
    }
    
    func saveBasketElement(_ basketElement: BasketElement) {
        if !checkAdded(basketElement) {
            try? realm.write {
                realm.add(basketElement)
            }
        }
    }
    
    private func checkAdded(_ basketElement: BasketElement) -> Bool {
        for element in basketElements {
            if element.name == basketElement.name && element.calories == basketElement.calories {
                try? realm.write {
                    element.count += basketElement.count
                }
                return true
            }
        }
        return false
    }
    
    func changeBasketElementCount(_ basketElement: BasketElement, number: Int) {
        try? realm.write {
            basketElement.count += number
        }
    }
    
    func deleteBasketElement(_ basketElement: BasketElement) {
        try? realm.write {
            realm.delete(basketElement)
        }
    }
    
    func clearBasketElements() {
        try? realm.write {
            realm.delete(basketElements)
        }
    }
}
