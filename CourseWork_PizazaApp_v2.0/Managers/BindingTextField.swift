//
//  BindingTextField.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/25/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation
import UIKit

class BindingTextField: UITextField {
    
    var textChanged: (String) -> () = { _ in }
    
    func bind(callback: @escaping (String) -> ()) {
        textChanged = callback
        self.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
    }
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        textChanged(textField.text!)
    }
}

class BindingImageView: UIImageView {
    
    var imageChanged: (UIImage) -> () = { _ in }
    
    func bind(callback: @escaping (UIImage) -> ()) {
        imageChanged = callback
    }
}
