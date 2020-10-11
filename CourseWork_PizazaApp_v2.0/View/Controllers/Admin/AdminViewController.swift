//
//  AdminViewController.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/16/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController {
    
    var adminRole = UserRoleRoot.admin
    var adminViewModel = AdminDeliverymanViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewDelegates()
        start()
    }
    
    func tableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func start() {
        adminViewModel.addDocToArray(role: adminRole) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
   
    func showAlertWithAction() {
        let alert = UIAlertController(title: R.string.localizable.alertTitle(), message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = R.string.localizable.emailPlaceholder()
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
            let tf = alert.textFields![0] as UITextField
            self.adminViewModel.addUser(email: tf.text!) { [weak self] (status) in
                guard let self = self else { return }
                if status {
                    self.start()
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension AdminViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adminViewModel.appUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.adminTableViewCell, for: indexPath) else {
            let cell = UITableViewCell()
            return cell
        }
        cell.emailLabel.text = adminViewModel.appUsers[indexPath.row].email
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            adminViewModel.deleteUser(user: adminViewModel.appUsers[indexPath.row]) { [weak self] (status) in
                guard let self = self else { return }
                if status {
                    self.start()
                }
            }
        }
    }
}

extension AdminViewController: RoleViewControllerDelegate {
    func addNewUser() {
        showAlertWithAction()
    }
}
