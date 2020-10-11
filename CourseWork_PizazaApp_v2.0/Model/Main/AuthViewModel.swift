//
//  AuthViewModel.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/11/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn

class AuthViewModel: NSObject {
    
    typealias authenticationLoginCallBack = (_ status: Bool, _ message: String) -> Void
    typealias roleCompletion = (_ role: String) -> Void
    
    var emailT: String! = ""
    var passwordT: String! = ""
    var db = Firestore.firestore()
    var adminsRoot: CollectionReference {
        return db.collection("users").document("admin").collection("allAdmins")
    }
    var deliverymansRoot: CollectionReference {
        return db.collection("users").document("deliveryman").collection("allDeliverymans")
    }
    
    var simpleRoot: CollectionReference {
        return db.collection("users").document("simple").collection("allSimple")
    }    
    
    func authenticateUserWith(closure: @escaping authenticationLoginCallBack) {
        if emailT.count  != 0 {
            if passwordT.count != 0 {
                Auth.auth().signIn(withEmail: emailT, password: passwordT) { (result, error) in
                    if error != nil {
                        closure(false, R.string.localizable.respWrongEmailOrPass())
                    } else {
                        closure(true, "")
                    }
                }
            } else {
                /// password empty
                closure(false, R.string.localizable.responseEmptyPassword())
            }
        } else {
            /// email empty
            closure(false, R.string.localizable.responseEmptyEmail())
        }
    }
  
    func authenticareWithGoogle() {
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func getUserAndChangeVC(completion: @escaping roleCompletion) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.adminsRoot.getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Snapshot admin error ", error)
                        return
                    }
                    if let documents = snapshot?.documents {
                        for document in documents {
                            guard let email = document.data()["email"] as? String else {
                                print ("document admin email error")
                                return }
                            if email == user.email {
                                completion("admin")
                            }
                        }
                    }
                }
                self.deliverymansRoot.getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Snapshot deliveryman error ", error)
                        return
                    }
                    if let documents = snapshot?.documents {
                        for document in documents {
                            guard let email = document.data()["email"] as? String else {
                                print ("document deliveryman email error")
                                return }
                            if email == user.email {
                                completion("deliveryman")
                            }
                        }
                    }
                }
                self.simpleRoot.getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Snapshot deliveryman error ", error)
                        return
                    }
                    if let documents = snapshot?.documents {
                        for document in documents {
                            guard let email = document.data()["email"] as? String else {
                                print ("document deliveryman email error")
                                return }
                            if email == user.email {
                                completion("simple")
                            }
                        }
                    }
                }
            }
        }
    }
}

extension AuthViewModel: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            return
        }

        guard let authentication = user.authentication else {
            print("authentication")
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)

        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                print("Some sign in error ", error)
                return
            }
            print("Good")
            guard let uid = result?.user.uid else { return }
            guard let email = result?.user.email else { return }
            self.simpleRoot.document(email).setData([
                                                    "email": email,
                                                    "uid": uid
                                                    ],
                                                    merge: true)
        }
    }
}


