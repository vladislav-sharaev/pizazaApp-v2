//
//  DeliveryViewModel.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 10/8/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation
import Firebase

class DeliveryViewModel {
    
    var orderArray = [Order]()
    let db = Firestore.firestore()
    var orderRoot: CollectionReference {
        return db.collection("order")
    }
    
    func config(completion: @escaping (Error?) -> Void) {
        orderArray.removeAll()
        orderRoot.getDocuments { (snapshot, error) in
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
                    
                    self.orderRoot.document(onDate).collection("foodComponent").getDocuments { (snapshot, error) in
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
    
    func makeCompleted(order: Order, completion: @escaping (Error?) -> Void) {
        db.collection("competedOrder").document(order.onDate).setData([
            "name": order.name,
            "telephone": order.telephone,
            "adress": order.address,
            "date": order.date,
            "finalCost": order.finalCost,
            "porch": order.porch as Any,
            "floor": order.floor as Any,
            "code": order.code as Any,
            "room": order.room as Any,
            "onDate": order.onDate
        ], merge: true) { error in
            if error != nil {
                completion(error)
                return
            }
        }
        
        for element in order.food {
            let doc = element.name + " " + String(element.calories)
            db.collection("competedOrder").document(order.onDate).collection("foodComponent").document(doc).setData([
                "name": element.name,
                "calories": element.calories,
                "cost": element.cost,
                "ingridients": element.ingridients as Any,
                "url": element.url,
                "cu": element.cu,
                "count": element.count
            ], merge: true) { error in
                if error != nil {
                    completion(error)
                    return
                }
            }
        }
                
        orderRoot.document(order.onDate).delete() { error in
            if let error = error {
                completion(error)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    func signOut(completion: (Error?) -> Void) {
        do {
            print(Auth.auth().currentUser?.uid as Any)
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            print("Error here when sign out, ", error)
            completion(error)
        }
    }
}
