//
//  RegistrationViewModel.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/11/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class RegistrationViewModel {
    
    typealias registrationLoginCallBack = (_ status: Bool, _ message: String) -> Void
    var emailT: String! = ""
    var passwordT: String! = ""
    var db = Firestore.firestore()
    var simpleRoot: CollectionReference {
        return db.collection("users").document("simple").collection("allSimple")
    }
    
    func registerUserWith(closure: @escaping registrationLoginCallBack) {
        if emailT.count  != 0 {
            if passwordT.count != 0 {
                let text = filterContent(searchText: R.string.localizable.numbers(), strToFiltr: passwordT)
                if passwordT == text {
                    Auth.auth().createUser(withEmail: emailT, password: passwordT) { (result, error) in
                        if error != nil {
                            /// какая-то ошибка, связанная с самим сервером
                            /// вывожу неизвестную ошибку, так как не знаю, как локализовать её
                            closure(false, R.string.localizable.respUnknownError())
                        } else {
                            guard let uid = result?.user.uid else { return }
                            guard let email = result?.user.email else { return }
                            self.simpleRoot.document(email).setData([
                                        "email": email,
                                        "uid": uid,
                                        "role": "simple"], merge: true)
                            closure(true, "")
                        }
                    }
                } else {
                    /// неверный формат данных
                    closure(false, R.string.localizable.respInvalidDataType())
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
    
    fileprivate func filterContent(searchText: String, strToFiltr: String) -> String {
        var text = strToFiltr
        text = strToFiltr.filter { searchText.contains($0) }
        return text
    }
}
