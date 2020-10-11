//
//  SharedFactory.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/30/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation

final class SharedFactory {
    
    static let shared = SharedFactory()
    let basketViewModel: BasketViewModel
    let likedFoodViewModel: LikedFoodViewModel
    
    private init() {
        basketViewModel = BasketViewModel()
        likedFoodViewModel = LikedFoodViewModel()
    }
}
