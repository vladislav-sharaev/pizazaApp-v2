//
//  LaunchUserViewController.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/19/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

class LaunchUserViewController: UIViewController {

    var launchUserViewModel = LaunchUserViewModel()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.alpha = 1
        
        self.launchUserViewModel.showVC { [weak self] (status, role) in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIView.animate(withDuration: 1) {
                    self.imageView.alpha = 0
                }
                if status {
                    switch role {
                    case "admin":
                        if let vc = R.storyboard.admin().instantiateInitialViewController() {
                            self.presentVC(vc)
                            break
                        }
                    case "deliveryman":
                        print("deliveryman")
                        if let vc = R.storyboard.deliveryman().instantiateInitialViewController() {
                            self.presentVC(vc)
                            break
                        }
                    default:
                        print("WHAT AM I DOING HERE???//SIMPLE")
                        if let vc = R.storyboard.simple().instantiateInitialViewController() {
                            self.presentVC(vc)
                            break
                        }
                    }
                } else {
                    if let vc = R.storyboard.main.authViewController() {
                        self.presentVC(vc)
                    }
                }
            }
        }
    }
    
    private func presentVC(_ vc: UIViewController) {
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
