//
//  ProfileSettingsViewModel.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 10/3/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation
import Firebase

class ProfileSettingsViewModel {
    
    let db = Firestore.firestore()
    var userRoot: DocumentReference {
        return db.collection("users").document("simple").collection("allSimple").document((Auth.auth().currentUser?.email)!)
    }
    
    func saveUserName(name: String, completion: @escaping (String, String) -> Void) {
        if name.count < 3 || name.count > 20 {
            completion(R.string.localizable.errorTitle(), R.string.localizable.respInvalidDataType())
            return
        }
        userRoot.setData([
            "name": name
        ], merge: true) { error in
            if error == nil {
                completion(R.string.localizable.successTitle(), R.string.localizable.dataSaved())
            } else {
                print("Error add doc", error?.localizedDescription as Any)
                completion(R.string.localizable.errorTitle(), R.string.localizable.respUnknownError())
            }
        }
    }
    
    func saveUserTelephone(telephone: String, completion: @escaping (String, String) -> Void) {
        if telephone.count != 11 {
            completion(R.string.localizable.errorTitle(), R.string.localizable.respInvalidDataType())
            return
        }
        userRoot.setData([
            "telephone": telephone
        ], merge: true) { error in
            if error == nil {
                completion(R.string.localizable.successTitle(), R.string.localizable.dataSaved())
            } else {
                print("Error add doc", error?.localizedDescription as Any)
                completion(R.string.localizable.errorTitle(), R.string.localizable.respUnknownError())
            }
        }
    }
    
    func filterTF(numberText: String, completion: (Bool) -> Void) {
        let text = filterContent(searchText: R.string.localizable.numbers(), strToFiltr: numberText)
        if numberText.count > 11 {
            completion(false)
        }
        if numberText == text {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    fileprivate func filterContent(searchText: String, strToFiltr: String) -> String {
        var text = strToFiltr
        text = strToFiltr.filter { searchText.contains($0) }
        return text
    }
    
    func signOut(completion: (Bool, String?, String?, Error?) -> Void) {
        do {
            print(Auth.auth().currentUser?.uid as Any)
            try Auth.auth().signOut()
            //Исправить
            completion(true, nil, nil,nil)
        } catch let error {
            print("Error here when sign out, ", error)
            completion(false, R.string.localizable.errorTitle(), R.string.localizable.respUnknownError(), error)
        }
    }
    
    func changePasswordWith(closure: @escaping (Bool, String?, String?, Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: (Auth.auth().currentUser?.email)!) { (error) in
            if error != nil {
                closure(false, R.string.localizable.errorTitle(), R.string.localizable.respUnknownError(), error)
            } else {
                closure(true, R.string.localizable.successTitle(), R.string.localizable.respSendNewPass(), nil)
            }
        }
    }
}
