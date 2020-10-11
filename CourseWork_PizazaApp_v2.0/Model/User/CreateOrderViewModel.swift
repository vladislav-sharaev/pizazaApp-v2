//
//  CreateOrderViewModel.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 10/3/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation
import Firebase

class CreateOrderViewModel {
    
    var finalCost = 0.0
    let db = Firestore.firestore()
    var userRoot: DocumentReference {
        return db.collection("users").document("simple").collection("allSimple").document((Auth.auth().currentUser?.email)!)
    }
    
    var userOrderRoot: CollectionReference {
        return db.collection("users").document("simple").collection("allSimple").document((Auth.auth().currentUser?.email)!).collection("orderHistory")
    }
    
    var orderRoot: CollectionReference {
        return db.collection("order")
    }
    
    func getData(completion: @escaping (String?, String?) -> Void) {
        userRoot.getDocument { (document, error) in
            if error != nil {
                completion(nil, nil)
                return
            }
            if let document = document {
                let name = document.data()?["name"] as? String
                let telephone = document.data()?["telephone"] as? String
                completion(name, telephone)
            }
        }
    }
    
    func outOfRange(textField: UITextField, completion: (String, String?) -> Void) {
        guard let text = textField.text else { return }
        if text.count != 11 {
            completion(R.string.localizable.errorTitle(), R.string.localizable.respInvalidDataType())
            textField.text = ""
        }
    }
    
    func order(nameTF: UITextField, telephoneTF: UITextField, adressLabel: UILabel, dataTF: UITextField, finalCost: Double, porchTF: UITextField, floorTF: UITextField, codeTF: UITextField, roomTF: UITextField, completion: @escaping (Bool, String, String?) -> Void) {
        if nameTF.text == "" || telephoneTF.text == "" || adressLabel.text == "" || dataTF.text == "" || telephoneTF.text?.count != 11 {
            completion(false, R.string.localizable.errorTitle(), R.string.localizable.writeAllMustHaveFields())
            return
        }
        
        userOrderRoot.document(dataTF.text!).setData([
            "name": nameTF.text!,
            "telephone": telephoneTF.text!,
            "adress": adressLabel.text!,
            "date": getCurrentDate(),
            "finalCost": finalCost,
            "porch": porchTF.text as Any,
            "floor": floorTF.text as Any,
            "code": codeTF.text as Any,
            "room": roomTF.text as Any,
            "onDate": dataTF.text!
        ], merge: true) { error in
            if error != nil {
                completion(false, R.string.localizable.errorTitle(), R.string.localizable.respUnknownError())
                return
            }
        }
        
        orderRoot.document(dataTF.text!).setData([
            "name": nameTF.text!,
            "telephone": telephoneTF.text!,
            "adress": adressLabel.text!,
            "date": getCurrentDate(),
            "finalCost": finalCost,
            "porch": porchTF.text as Any,
            "floor": floorTF.text as Any,
            "code": codeTF.text as Any,
            "room": roomTF.text as Any,
            "onDate": dataTF.text!,
            "ready": false
        ], merge: true) { error in
            if error != nil {
                completion(false, R.string.localizable.errorTitle(), R.string.localizable.respUnknownError())
                return
            }
        }
        
        for element in SharedFactory.shared.basketViewModel.basketArray {
            let doc = element.name + " " + String(element.calories)
            userOrderRoot.document(dataTF.text!).collection("foodComponent").document(doc).setData([
                "name": element.name,
                "calories": element.calories,
                "cost": element.cost,
                "ingridients": element.ingridients as Any,
                "url": element.url,
                "cu": element.cu,
                "count": element.count
            ], merge: true) { error in
                if error != nil {
                    completion(false, R.string.localizable.errorTitle(), R.string.localizable.respUnknownError())
                    return
                }
            }
            
            orderRoot.document(dataTF.text!).collection("foodComponent").document(doc).setData([
                "name": element.name,
                "calories": element.calories,
                "cost": element.cost,
                "ingridients": element.ingridients as Any,
                "url": element.url,
                "cu": element.cu,
                "count": element.count
            ], merge: true) { error in
                if error != nil {
                    completion(false, R.string.localizable.errorTitle(), R.string.localizable.respUnknownError())
                    return
                }
            }
        }
        completion(true, R.string.localizable.successTitle(), R.string.localizable.orderSuccessMessage())
        //создать заказ в order для работников
        //создать foodComponent для этого заказа и там, и там
    }
    
    func getCurrentDate() -> String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter.string(from: currentDateTime)
    }
}

//"October 5, 2020 at 12:06:13 AM"
//formatter.timeStyle = .medium
//formatter.dateStyle = .long

//"10/5/20, 12:07 AM"
//formatter.timeStyle = .short
//formatter.dateStyle = .short

//!
//"Oct 5, 2020 at 12:09 AM"
//formatter.timeStyle = .short
//formatter.dateStyle = .medium
