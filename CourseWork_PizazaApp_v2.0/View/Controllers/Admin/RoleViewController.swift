//
//  AdminViewController.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/15/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

protocol RoleViewControllerDelegate {
    func addNewUser()
}

class RoleViewController: UIViewController {

    var roleViewModel = RoleViewModel()
    var childViewController: UIViewController = R.storyboard.admin.adminViewController()!
    var delegate: RoleViewControllerDelegate?

    @IBOutlet weak var roleSegmentedControl: UISegmentedControl!
    @IBOutlet weak var childView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLocalization()
        start()
    }
    
    @IBAction func roleSCAction(_ sender: UISegmentedControl) {
        start()
    }
    
    @IBAction func addNewUserAction(_ sender: UIBarButtonItem) {
        delegate?.addNewUser()
    }
    
    @IBAction func logoutAction(_ sender: UIBarButtonItem) {
        guard let vc = presentingViewController else { return }
        roleViewModel.logOut(presentinVC: vc)
    }
    
    func configLocalization() {
        roleSegmentedControl.setTitle(R.string.localizable.adminSegmentedControl(), forSegmentAt: 0)
        roleSegmentedControl.setTitle(R.string.localizable.deliverymanSegmentedControl(), forSegmentAt: 1)
        self.title = R.string.localizable.roleNavigation()
    }
    
    func start() {
        roleViewModel.getChildVC(childView: childView, presentingVC: self) { [weak self] (vc) in
            guard let self = self else { return }
            self.delegate = vc as? RoleViewControllerDelegate
        }
    }
}
