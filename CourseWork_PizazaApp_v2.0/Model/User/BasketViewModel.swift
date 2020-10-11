//
//  BasketViewModel.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/30/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class BasketViewModel {
    
    var basketElementStorageCore: BasketElementStorageCore!
    var basketArray: [BasketElement] {
        get {
            getRealm()
            return basketElementStorageCore.getBasketElements()
        } 
    }
    
    func getRealm() {
        do {
            let realm = try Realm()
            basketElementStorageCore = BasketElementStorageCore(realm: realm)
        } catch {
            fatalError("Can't create realm object")
        }
    }
    
    func needShowTable() -> Bool {
        if basketArray.count == 0 {
            return true
        }
        return false
    }
    
    func returnTotalCost() -> Double {
        var totalCost = 0.0
        for element in basketArray {
            totalCost += element.cost * Double(element.count)
        }
        return totalCost.rounded(place: 2)
    }
    
    func pushVC(selfVC: UIViewController) {
        guard let vc = R.storyboard.simple.createOrderViewController() else { return }
        vc.createOrderViewModel.finalCost = returnTotalCost()
        selfVC.navigationController?.pushViewController(vc, animated: true)
    }
}
