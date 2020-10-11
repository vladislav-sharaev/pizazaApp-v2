//
//  CreateCategorieViewModel.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/20/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation
import UIKit

class CreateCategorieViewModel {
    
    var nameT: String! = ""
    var urlT: String! = ""
    
    func pushVC(image: UIImage?, completion: (Bool) -> Void) {
        if nameT != "" && urlT != "" && image != nil {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func loadImage(completion: @escaping (Bool, Data?) -> Void) {
        if let url = URL(string: urlT) {
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
}
