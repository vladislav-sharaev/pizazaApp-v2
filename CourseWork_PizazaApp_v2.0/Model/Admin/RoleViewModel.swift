//
//  RoleViewModel.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/16/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn

class RoleViewModel {
    
    typealias childTypeCallBack = (_ viewController: UIViewController) -> Void
    typealias controllerCallBack = (_ viewController: UIViewController) -> Void
    
    var childType = ChildType.admin
    
    func logOut(presentinVC: UIViewController) {
        do {
            print(Auth.auth().currentUser?.uid as Any)
            try Auth.auth().signOut()
            presentinVC.dismiss(animated: true, completion: nil)
        } catch let error {
            print("Logout error, ", error)
        }
    }
    
    func changeVC(childVC: UIViewController, childView: UIView, presentingVC: UIViewController) {
        clear(childView: childView, presentingVC: presentingVC)
        childVC.view.frame = childView.bounds
        presentingVC.addChild(childVC)
        childView.addSubview(childVC.view)
        childVC.didMove(toParent: presentingVC)
    }
    
    private func clear(childView: UIView, presentingVC: UIViewController) {
        for view in childView.subviews {
            view.removeFromSuperview()
        }
        if presentingVC.children.count > 0 {
            let VCs = presentingVC.children
            for vc in VCs {
                vc.willMove(toParent: nil)
                vc.view.removeFromSuperview()
                vc.removeFromParent()
            }
        }
    }
    
    func getChildVC(childView: UIView, presentingVC: UIViewController, closure: controllerCallBack) {
        switch childType {
        case .admin:
            childType = .deliveryman
            guard let vc = R.storyboard.admin.adminViewController() else { return }
            changeVC(childVC: vc, childView: childView, presentingVC: presentingVC)
            closure(vc)
            DispatchQueue.main.async {
                vc.start()
            }
        case .deliveryman:
            childType = .admin
            guard let vc = R.storyboard.admin.deliverymanViewController() else { return }
            changeVC(childVC: vc, childView: childView, presentingVC: presentingVC)
            closure(vc)
            DispatchQueue.main.async {
                vc.start()
            }
        }
    }
    
    func getType(number: Int) -> ChildType {
        if number == 0 {
            return .admin
        } else {
            return .deliveryman
        }
    }
}


