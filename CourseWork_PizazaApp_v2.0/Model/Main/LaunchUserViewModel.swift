//
//  LaunchUserViewModel.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/19/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation
import Firebase

class LaunchUserViewModel {
    
    let db = Firestore.firestore()
    var adminsRoot: CollectionReference {
        return db.collection("users").document("admin").collection("allAdmins")
    }
    var deliverymansRoot: CollectionReference {
        return db.collection("users").document("deliveryman").collection("allDeliverymans")
    }
    
    var simpleRoot: CollectionReference {
        return db.collection("users").document("simple").collection("allSimple")
    }
    
    func showVC(completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().addStateDidChangeListener({ (auth, user) in
            guard let user = user else {
                completion(false, nil)
                return
            }
            self.adminsRoot.getDocuments { (snapshot, error) in
                if let error = error {
                    print("Snapshot admin error ", error)
                    completion(false, nil)
                    return
                }
                if let documents = snapshot?.documents {
                    for document in documents {
                        guard let email = document.data()["email"] as? String else {
                            print ("document admin email error")
                            completion(false, nil)
                            return }
                        if email == user.email {
                            completion(true, "admin")
                        }
                    }
                }
            }
            self.deliverymansRoot.getDocuments { (snapshot, error) in
                if let error = error {
                    print("Snapshot deliveryman error ", error)
                    completion(false, nil)
                    return
                }
                if let documents = snapshot?.documents {
                    for document in documents {
                        guard let email = document.data()["email"] as? String else {
                            print ("document deliveryman email error")
                            completion(false, nil)
                            return }
                        if email == user.email {
                            completion(true, "deliveryman")
                        }
                    }
                }
            }
            self.simpleRoot.getDocuments { (snapshot, error) in
                if let error = error {
                    print("Snapshot deliveryman error ", error)
                    completion(false, nil)
                    return
                }
                if let documents = snapshot?.documents {
                    for document in documents {
                        guard let email = document.data()["email"] as? String else {
                            print ("document deliveryman email error")
                            return }
                        if email == user.email {
                            completion(true, "simple")
                        }
                    }
                }
            }
        })
    }
}
