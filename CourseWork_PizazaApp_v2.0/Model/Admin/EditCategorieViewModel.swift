//
//  EditCategorieViewModel.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/22/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation
import Firebase

class EditCategorieViewModel {
    
    var url: String! = ""
    var categorie: Categorie
    let db = Firestore.firestore()
    var root: DocumentReference {
        return db.collection("food").document(categorie.name)
    }
    
    init(categorie: Categorie) {
        self.categorie = categorie
    }
    
    func popVC(image: UIImage?, completion: (Bool) -> Void) {
        if url != "" && image != nil {
            completion(true)
        } else {
            completion(false)
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

    func save(completion: @escaping (Bool) -> Void) {
        root.setData(["url": url as Any], merge: true) { error in
            if error != nil {
                print("Save error", error?.localizedDescription as Any)
                completion(false)
                return
            } else {
                completion(true)
            }
        }
    }
}
