//
//  ACategoriesViewModel.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/22/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation
import Firebase

class ACategoriesViewModel {
    
    var categorie: Categorie? 
    var categorieArray = [Categorie]()
    let db = Firestore.firestore()
    var foodRoot: CollectionReference {
        return db.collection("food")
    }
    
    func getSnapshotCount(completion: @escaping (Int) -> Void) {
        foodRoot.getDocuments { (snapshot, error) in
            if let error = error {
                print("FOOD snapshot error ", error)
                completion(0)
                return
            }
            guard let snapshotCount = snapshot?.count else {
                completion(0)
                return
            }
            completion(snapshotCount)
        }
    }
    
    func addDocToArray(completion: @escaping((Error?) -> ()))  {
        categorieArray.removeAll()
        foodRoot.getDocuments { (snapshot, error) in
            if let error = error {
                print("Categorie snapshot error ", error)
                completion(error)
                return
            }
            
            if let documents = snapshot?.documents {
                for document in documents {
                    guard let name = document.data()["name"] as? String else { print ("name error")
                        continue }
                    guard let url = document.data()["url"] as? String else { print ("url error")
                        continue }
                    var added = false
                    for element in self.categorieArray {
                        if element.name == name {
                            added = true
                        }
                    }
                    if !added {
                        self.categorieArray.append(Categorie(url: url, name: name))
                    }
                }
                completion(nil)
            } else {
                completion(error)
                print("doc error")
            }
        }
    }
    
    func getUsableArray() -> [Categorie] {
        var usableArray = categorieArray
        var i = 0
        for element in usableArray {
            if element.name == categorie?.name {
                usableArray.remove(at: i)
            }
            i += 1
        }
        return usableArray
    }
}
