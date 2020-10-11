//
//  AFoodCollectionViewModel.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/23/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation
import Firebase

class AFoodCollectionViewModel {
    
    var foodArray = [Food]()
    var foodArrayCountPlusOne: Int {
        get {
            return foodArray.count + 1
        }
    }
    var categorie: Categorie!
    let db = Firestore.firestore()
    var root: CollectionReference {
        return db.collection("food").document(categorie.name).collection(categorie.name)
    }
    var docRoot: DocumentReference {
        return db.collection("food").document(categorie.name)
    }
    
    func addDocToArray(completion: @escaping(() -> ()))  {
        foodArray.removeAll()
        root.getDocuments { (snapshot, error) in
            if let error = error {
                print("Categorie snapshot error ", error)
                return
            }
            
            if let documents = snapshot?.documents {
                for document in documents {
                    
                    guard let name = document.data()["name"] as? String else { print ("name error")
                        continue}
                    guard let maxCost = document.data()["maxCost"] as? Double else { print ("maxCost error")
                        continue}
                    var minCost: Double? = nil
                    if document.data()["minCost"] != nil {
                        minCost = document.data()["minCost"] as? Double
                    }
                    guard let maxCalories = document.data()["maxCalories"] as? Double else { print ("maxCalories error")
                        continue}
                    var minCalories: Double? = nil
                    if document.data()["minCalories"] != nil {
                        minCalories = document.data()["minCalories"] as? Double
                    }
                    var ingridients: String? = nil
                    if document.data()["ingridients"] != nil {
                        ingridients = document.data()["ingridients"] as? String
                    }
                    guard let url = document.data()["url"] as? String else { print ("url error")
                        continue}
                    guard let cu = document.data()["cu"] as? String else { print ("cu error")
                        continue}
                    
                    var added = false
                    for element in self.foodArray {
                        if element.name == name {
                            added = true
                        }
                    }
                    if !added {
                        self.foodArray.append(Food(name: name, ingridients: ingridients, url: url, maxCalories: maxCalories, minCalories: minCalories, maxCost: maxCost, minCost: minCost, cu: cu))
                    }
                }
                completion()
            } else {
                print("doc error")
            }
        }
    }
    
    func deleteFood(food: Food, completion: @escaping () -> Void) {
        root.document(food.name).delete() { error in
            if error != nil {
                print("some error with deleting", error?.localizedDescription as Any)
                return
            }
            completion()
        }
    }
    
   func deleteCollection(count: Int, completion: @escaping () -> Void) {
        if count - 1 == 0 {
            docRoot.delete() { error in
                if error != nil {
                    print("error with deleting collection", error?.localizedDescription as Any)
                    return
                }
                completion()
            }
        }
    }
}
