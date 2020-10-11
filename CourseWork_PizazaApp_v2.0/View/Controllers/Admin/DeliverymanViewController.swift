//
//  DeliverymanViewController.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/16/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class DeliverymanViewController: UIViewController {
    
    var deliverymanRole = UserRoleRoot.deliveryman
    var deliverymanViewModel = AdminDeliverymanViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewDelegates()
        start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func start() {
        deliverymanViewModel.addDocToArray(role: deliverymanRole) {
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
            self.deliverymanViewModel.addUser(email: tf.text!) { [weak self] (status) in
                guard let self = self else { return }
                if status {
                    self.start()
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension DeliverymanViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliverymanViewModel.appUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.deliverymanTableViewCell, for: indexPath) else {
            let cell = UITableViewCell()
            return cell
        }
        cell.emailLabel.text = deliverymanViewModel.appUsers[indexPath.row].email
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                deliverymanViewModel.deleteUser(user: deliverymanViewModel.appUsers[indexPath.row]) { [weak self] (status) in
                    guard let self = self else { return }
                    if status {
                        self.start()
                    }
                }
            }
        }
}

extension DeliverymanViewController: RoleViewControllerDelegate {
    func addNewUser() {
        showAlertWithAction()
    }
}
