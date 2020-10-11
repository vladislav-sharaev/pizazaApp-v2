//
//  AdminViewModel.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/15/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

enum UserRoleRoot {
    case admin
    case deliveryman
    
    var roleDocAndColl: (doc: String, coll: String) {
       switch self {
       case .admin:
            return ("admin", "allAdmins")
        case .deliveryman:
            return ("deliveryman", "allDeliverymans")
        }
    }
}

class AdminDeliverymanViewModel {
    
    var appUsers = [AppUser]()
    var userRole = UserRoleRoot.admin
    var roleRoot: (doc: String, coll: String) {
        return userRole.roleDocAndColl
    }
    let db = Firestore.firestore()
    var root: CollectionReference {
        return db.collection("users").document(roleRoot.doc).collection(roleRoot.coll)
    }
    var simpleRoot: CollectionReference {
        return db.collection("users").document("simple").collection("allSimple")
    }
        
    func getSnapshotCount(role: UserRoleRoot) -> Int {
        var count = 0
        userRole = role
        root.getDocuments { (snapshot, error) in
            if let error = error {
                print("Admin/Deliveryman snapshot error ", error)
                return
            }
            guard let snapshot = snapshot else { return }
            count = snapshot.count
        }
        return count
    }
    
    func addDocToArray(role: UserRoleRoot, completion: @escaping(() -> ()))  {
        userRole = role
        appUsers.removeAll()
        root.getDocuments { (snapshot, error) in
            if let error = error {
                print("Admin/Deliveryman snapshot error ", error)
                return
            }
            if let documents = snapshot?.documents {
                for document in documents {
                    guard let email = document.data()["email"] as? String else { print ("email error")
                        return }
                    guard let uid = document.data()["uid"] as? String else { print ("uid error")
                    return }
                    guard let role = document.data()["role"] as? String else { print ("role error")
                    return }
                    var added = false
                    for element in self.appUsers {
                        if element.email == email {
                            added = true
                        }
                    }
                    if !added {
                        self.appUsers.append(AppUser(email: email, uid: uid, role: role))
                    }
                }
                completion()
            } else {
                print("doc error")
            }
        }
    }
    
    func deleteUser(user: AppUser, completion: @escaping (Bool) -> Void) {
        root.document(user.email).delete { (error) in
            if error != nil {
                print("Delete error")
                return
            }
            self.simpleRoot.document(user.email).setData([
                "email": user.email,
                "uid": user.uid,
                "role": "simple"], merge: true)
            completion(true)
        }
    }
    
    func addUser(email: String, completion: @escaping (Bool) -> Void) {
        //МОЖЕТ БЫТЬ ОШИБКА
        var added = false
        for element in appUsers {
            if element.email == email {
                added = true
            }
        }
        if !added {
            simpleRoot.getDocuments { (snapshot, error) in
                if let error = error {
                    print("Simple snapshot error ", error)
                    return
                }
                if let documents = snapshot?.documents {
                    for document in documents {
                        guard let emailU = document.data()["email"] as? String else { print ("email error")
                            continue }
                        guard let uid = document.data()["uid"] as? String else { print ("uid error")
                            continue }
                        var role: String? = nil
                        if document.data()["role"] != nil {
                            role = document.data()["role"] as? String
                        }
                        
                        if email == emailU {
                            let user = AppUser(email: email, uid: uid, role: role)
                            self.simpleRoot.document(user.email).delete { (error) in
                                if error != nil {
                                    print("Delete error")
                                    completion(false)
                                    return
                                }
                                self.root.document(user.email).setData([
                                    "email": user.email,
                                    "uid": user.uid,
                                    "role": self.roleRoot.doc])
                                completion(true)
                            }
                        }
                    }
                } else {
                    print("doc error when create user")
                }
            }
        }
    }
}
