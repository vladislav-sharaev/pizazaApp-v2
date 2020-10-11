//
//  ProfileSettingsViewController.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 10/3/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

class ProfileSettingsViewController: UIViewController {
    
    var profileSettingsViewModel = ProfileSettingsViewModel()
    var createOrderViewModel = CreateOrderViewModel()

    @IBOutlet weak var userDataLabel: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var telephoneTF: UITextField!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var changePassBtn: UIButton!
    @IBOutlet weak var exitBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLocalization()
        addTFDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        writeTF()
    }
    
    //Editing did end
    @IBAction func nameTF(_ sender: UITextField) {
        profileSettingsViewModel.saveUserName(name: nameTF.text!) { [weak self] (title, message) in
            guard let self = self else { return }
            self.showAlertWithoutAction(title: title, message: message)
        }
    }
    
    @IBAction func telephoneTFAction(_ sender: UITextField) {
        profileSettingsViewModel.saveUserTelephone(telephone: telephoneTF.text!) { [weak self] (title, message) in
            guard let self = self else { return }
            self.showAlertWithoutAction(title: title, message: message)
        }
    }
    
    //editing change
    @IBAction func telephoneTFEditingChange(_ sender: UITextField) {
        filterTF(textField: telephoneTF)
    }
    
    @IBAction func changePassBtnAction(_ sender: UIButton) {
        profileSettingsViewModel.changePasswordWith { [weak self] (success, title, message, error) in
            guard let self = self else { return }
            if success {
                self.showAlertWithoutAction(title: title!, message: message)
            } else {
                self.showAlertWithoutAction(title: title!, message: message)
            }
        }
    }
    
    @IBAction func exitBtnAction(_ sender: UIBarButtonItem) {
        profileSettingsViewModel.signOut { [weak self] (success, title, message, error) in
            guard let self = self else { return }
            if success {
                SharedFactory.shared.basketViewModel.basketElementStorageCore.clearBasketElements()
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showAlertWithoutAction(title: title!, message: message)
            }
        }
    }
    
    func configLocalization() {
        userDataLabel.text = R.string.localizable.userDataText()
        nameTF.placeholder = R.string.localizable.nameTFPlaceholder()
        telephoneTF.placeholder = R.string.localizable.telephoneTFPlaceholder()
        changePassBtn.setTitle(R.string.localizable.changePasswordBtn(), for: .normal)
        exitBtn.title = R.string.localizable.exitBtn()
    }
    
    func addTFDelegate() {
        nameTF.delegate = self
        telephoneTF.delegate = self
    }
    
    func filterTF(textField: UITextField) {
        guard let text = textField.text else { return }
        profileSettingsViewModel.filterTF(numberText: text) { (status) in
            if !status {
                textField.text = ""
            }
        }
    }
    
    func writeTF() {
        createOrderViewModel.getData { [weak self] (name, telephone) in
            guard let self = self else { return}
            DispatchQueue.main.async {
                self.nameTF.text = name
                self.telephoneTF.text = telephone
            }
        }
    }
    
    func showAlertWithoutAction(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithAction(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alert) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProfileSettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
