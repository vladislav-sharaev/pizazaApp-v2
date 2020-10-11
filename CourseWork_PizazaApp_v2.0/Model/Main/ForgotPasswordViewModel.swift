//
//  ForgotPasswordViewModel.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/11/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class ForgotPasswordViewModel {
    
    typealias authenticationLoginCallBack = (_ status: Bool, _ message: String) -> Void
    var emailT: String! = ""
    
    func changePasswordWith(closure: @escaping authenticationLoginCallBack) {
        if emailT.count  != 0 {
            Auth.auth().sendPasswordReset(withEmail: emailT) { (error) in
                if error != nil {
                    closure(false, R.string.localizable.respWrongEmail())
                } else {
                    closure(true, R.string.localizable.respSendNewPass())
                }
            }
        } else {
            /// email empty
            closure(false, R.string.localizable.responseEmptyEmail())
        }
    }
}
