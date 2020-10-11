//
//  LikedFoodViewModel.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 10/8/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation
import Firebase

class LikedFoodViewModel {
    
    var usableLikedFoodArray = [Food]()
    let db = Firestore.firestore()
    var userLikedFoodRoot: CollectionReference {
        return db.collection("users").document("simple").collection("allSimple").document((Auth.auth().currentUser?.email)!).collection("likedFood")
    }
    
    func likeUnlike(food: Food, completion: @escaping (Error?) -> Void) {
        var counter = 0
        for element in usableLikedFoodArray {
            if element.name == food.name {
                userLikedFoodRoot.document(element.name).delete() { (error) in
                    if let error = error {
                        completion(error)
                        return
                    }
                    //self.likedFoodArray.remove(at: counter)
                    self.usableLikedFoodArray.remove(at: counter)
                    print("Удаление прошло успешно")
                    completion(nil)
                    return
                }
                return
            } else {
                 counter += 1
            }
        }
        userLikedFoodRoot.document(food.name).setData([
            "name": food.name,
            "ingridients": food.ingridients as Any,
            "maxCalories": food.maxCalories,
            "minCalories": food.minCalories as Any,
            "maxCost": food.maxCost,
            "minCost": food.minCost as Any,
            "url": food.url,
            "cu": food.cu
        ], merge: true) { error in
            if error != nil {
                completion(error)
            } else {
                self.usableLikedFoodArray.append(food)
                print("Добавление прошло успешно")
                completion(nil)
            }
        }
        
    }
    
    func getUsableLikedFood(completion: @escaping (Error?) -> Void) {
        usableLikedFoodArray.removeAll()
        userLikedFoodRoot.getDocuments { (snapshot, error) in
            if let error = error {
                completion(error)
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
                                        
                self.usableLikedFoodArray.append(Food(name: name, ingridients: ingridients, url: url, maxCalories: maxCalories, minCalories: minCalories, maxCost: maxCost, minCost: minCost, cu: cu))
                }
            } else {
                completion(nil)
            }
        }
    }
}
