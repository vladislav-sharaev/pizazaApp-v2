//
//  OneFoodViewModel.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/30/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

enum Size {
    case standart
    case min
}

class OneFoodViewModel {
    
    var size: Size = .standart
    var food: Food!
    var count = 1
    var basketElement: BasketElement!

    func getNewSize() {
        
    }
    
    func config(completion: @escaping (UIImage?) -> Void) {
        if let url = URL(string: food.url) {
            UrlLoaderManager.shared.downloadImage(url: url) { (result) in
                switch result {
                case .success(let data):
                    let image = UIImage(data: data)
                    completion(image)
                case .failure(let error):
                    let image: UIImage = .remove
                    completion(image)
                    print(error)
                }
            }
        }
    }
    
    func makeSelected(that label: UILabel, and button: UIButton, insteadOf unselectedLabel: UILabel, and unselectedButton: UIButton) {
        //change btn and label color
        button.setTitleColor(.red, for: .normal)
        label.layer.borderColor = UIColor.red.cgColor
        
        unselectedButton.setTitleColor(.lightGray, for: .normal)
        unselectedLabel.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func changeCostAndCaloriesLabels(size: Size, caloriesLabel: UILabel, costLabel: UILabel) {
        //change calories and cost labels
        if size == .standart {
            caloriesLabel.text = String(food.maxCalories.rounded(place: 2)) + " " + food.cu
            costLabel.text = String(food.maxCost.rounded(place: 2)) + " " + R.string.localizable.br()
        } else if let minCalories = food.minCalories, let minCost = food.minCost {
            
            let minCaloriesTxt = String(minCalories.rounded(place: 2))
            let minCostTxt = String(minCost.rounded(place: 2))

            caloriesLabel.text = minCaloriesTxt + " " + food.cu
            costLabel.text = minCostTxt + " " + R.string.localizable.br()
        }
    }
    
    func increaseFoodCount(_ byNumber: Int, label: UILabel) {
        if count == 1 && byNumber < 0 {
            return
        }
        count += byNumber
        label.text = String(count)
    }
    
    func makeSmallSizeBtnEnable(_ button: UIButton) {
        if food.minCost == nil || food.minCalories == nil {
            button.isEnabled = false
        }
    }
    
    func addFoodToBasket() {
        switch size {
        case .standart:
            basketElement = BasketElement()
            basketElement.name = food.name
            basketElement.calories = food.maxCalories
            basketElement.cost = food.maxCost
            basketElement.ingridients = food.ingridients
            basketElement.url = food.url
            basketElement.count = count
            basketElement.cu = food.cu
            SharedFactory.shared.basketViewModel.getRealm()
            SharedFactory.shared.basketViewModel.basketElementStorageCore.saveBasketElement(basketElement)
        default:
            basketElement = BasketElement()
            basketElement.name = food.name
            basketElement.calories = food.minCalories!
            basketElement.cost = food.minCost!
            basketElement.ingridients = food.ingridients
            basketElement.url = food.url
            basketElement.count = count
            basketElement.cu = food.cu
            SharedFactory.shared.basketViewModel.getRealm()
            SharedFactory.shared.basketViewModel.basketElementStorageCore.saveBasketElement(basketElement)
        }
    }
}
