//
//  OrderHistoryViewModel.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 10/6/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation
import Firebase

class OrderHistoryViewModel {
    
    var orderArray = [Order]()
    var reversedArray: [Order] {
        return orderArray.reversed()
    }
    let db = Firestore.firestore()
    var orderHistoryRoot: CollectionReference {
        return db.collection("users").document("simple").collection("allSimple").document((Auth.auth().currentUser?.email)!).collection("orderHistory")
    }
    
    func config(completion: @escaping (Error?) -> Void) {
        orderArray.removeAll()
        orderHistoryRoot.getDocuments { (snapshot, error) in
            if let error = error {
                print("OrderHistoryViewModel snapshot error ", error)
                completion(error)
                return
            }
            if let documents = snapshot?.documents {
                for document in documents {
                    //must have
                    guard let address = document.data()["adress"] as? String else { print ("adress error")
                        continue }
                    guard let date = document.data()["date"] as? String else { print ("date error")
                    continue }
                    guard let onDate = document.data()["onDate"] as? String else { print ("onDate error")
                    continue }
                    guard let name = document.data()["name"] as? String else { print ("name error")
                    continue }
                    guard let telephone = document.data()["telephone"] as? String else { print ("telephone error")
                    continue }
                    guard let finalCost = document.data()["finalCost"] as? Double else { print ("finalCost error")
                    continue }
                    
                    //can be nil
                    var code: String? = nil
                    if document.data()["code"] != nil {
                        code = document.data()["code"] as? String
                    }
                    var floor: String? = nil
                    if document.data()["floor"] != nil {
                        floor = document.data()["floor"] as? String
                    }
                    var porch: String? = nil
                    if document.data()["porch"] != nil {
                        porch = document.data()["porch"] as? String
                    }
                    var room: String? = nil
                    if document.data()["room"] != nil {
                        room = document.data()["room"] as? String
                    }
                    
                    let newOrder = Order(address: address, date: date, onDate: onDate, code: code, finalCost: finalCost, floor: floor, name: name, porch: porch, room: room, telephone: telephone)
                    
                    var added = false
                    for element in self.orderArray {
                        if element.date == date {
                            added = true
                        }
                    }
                    if !added {
                        self.orderArray.append(newOrder)
                    }
                    
                    self.orderHistoryRoot.document(onDate).collection("foodComponent").getDocuments { (snapshot, error) in
                        if let error = error {
                            print("OrderHistoryViewModel snapshot error ", error)
                            completion(error)
                            return
                        }
                        if let documents = snapshot?.documents {
                            for document in documents {
                                //must have
                                guard let url = document.data()["url"] as? String else { print ("url error")
                                continue }
                                guard let cu = document.data()["cu"] as? String else { print ("cu error")
                                continue }
                                guard let count = document.data()["count"] as? Int else { print ("count error")
                                    continue }
                                guard let name = document.data()["name"] as? String else { print ("name error")
                                    continue }
                                guard let cost = document.data()["cost"] as? Double else { print ("cost error")
                                    continue }
                                guard let calories = document.data()["calories"] as? Double else { print ("calories error")
                                    continue }
                            
                                var ingridients: String? = nil
                                if document.data()["ingridients"] != nil {
                                    ingridients = document.data()["ingridients"] as? String
                                }
                                
                                let newFood = BasketElement()
                                newFood.name = name
                                newFood.url = url
                                newFood.cu = cu
                                newFood.count = count
                                newFood.cost = cost
                                newFood.calories = calories
                                newFood.ingridients = ingridients
                                
                                var nAdded = false
                                for element in newOrder.food {
                                    if element.name == name && element.calories == calories {
                                        nAdded = true
                                    }
                                }
                                if !nAdded {
                                    newOrder.food.append(newFood)
                                }
                            }
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
}
