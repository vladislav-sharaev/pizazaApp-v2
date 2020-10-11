//
//  CreateFoodViewModel.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/21/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation
import Firebase
import UIKit


class CreateFoodViewModel {
    
    var name: String! = ""
    var ingridients: String? = ""
    var maxCalories: String! = ""
    var minCalories: String? = ""
    var maxCost: String! = ""
    var minCost: String? = ""
    var url: String! = ""
    var cu: String! = ""
    
    var food: (food: Food?, notAlone: Bool?)
    var categorieName: String
    var categorieImgUrl: String
    let db = Firestore.firestore()
    var foodRoot: CollectionReference {
        return db.collection("food").document(categorieName).collection(categorieName)
    }
    var categorieRoot: DocumentReference {
        return db.collection("food").document(categorieName)
    }
    
    init(categorieName: String, categorieImgUrl: String) {
        self.categorieName = categorieName
        self.categorieImgUrl = categorieImgUrl
    }
    
    func createNewFood(completion: @escaping (Bool) -> Void) {
        if food.food == nil {
            categorieRoot.setData(["url": categorieImgUrl,
            "name": categorieName], merge: true) { error in
                if error != nil {
                    print("Error add doc", error?.localizedDescription as Any)
                    completion(false)
                    return
                }
            }
        }
        let maxCal = Double(maxCalories)
        let maxC = Double(maxCost)
        
        var minCal: Double? = nil
        if minCalories != nil {
            minCal = Double(minCalories!)
        }
        var minC: Double? = nil
        if minCost != nil {
            minC = Double(minCost!)
        }
        foodRoot.document(name).setData([
            "name": self.name as Any,
            "ingridients": self.ingridients as Any,
            "maxCalories": maxCal as Any,
            "minCalories": minCal as Any,
            "maxCost": maxC as Any,
            "minCost": minC as Any,
            "url": self.url as Any,
            "cu": self.cu as Any
        ], merge: true) { error in
            if error == nil {
                completion(true)
            } else {
                print("Error add doc", error?.localizedDescription as Any)
                completion(false)
            }
        }
    }
      
    func enableBtn(image: UIImage?, completion: () -> Void) {
        if name != "" && maxCalories != "" && maxCost != "" && url != "" && image != nil && cu != "" {
            completion()
        }
    }
   
    func loadImage(completion: @escaping (Bool, Data?) -> Void) {
        if let url = URL(string: url) {
            UrlLoaderManager.shared.downloadImage(url: url) { [weak self] (result) in
                guard self != nil else { return }
                switch result {
                case .success(let data):
                    completion(true, data)
                case .failure(let error):
                    print(error)
                    completion(false, nil)
                }
            }
        } else {
            completion(false, nil)
        }
    }
    
    func filterTF(numberText: String, completion: (Bool) -> Void) {
        let text = filterContent(searchText: R.string.localizable.numbers() + ".", strToFiltr: numberText)
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
    
    func needCreate(completion: (Bool) -> Void) {
        if self.food.food == nil {
            completion(true)
        } else {
            completion(false)
        }
    }
} 
