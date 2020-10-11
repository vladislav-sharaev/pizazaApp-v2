//
//  RegistrationViewController.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/10/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    var registrationViewModel = RegistrationViewModel()
    
    @IBOutlet weak var emailTF: BindingTextField! {
        didSet {
            emailTF.bind { self.registrationViewModel.emailT = $0 }
        }
    }
    @IBOutlet weak var passwordTF: BindingTextField! {
        didSet {
            passwordTF.bind { self.registrationViewModel.passwordT = $0 }
        }
    }
    @IBOutlet weak var registrationBtn: UIButton!
    //view for error
    @IBOutlet weak var responseAI: UIActivityIndicatorView!
    @IBOutlet weak var responseView: UIView!
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var respVWidth: NSLayoutConstraint!
    @IBOutlet weak var respVHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLocalization()
        addTFDelegate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.first != nil {
            view.endEditing(true)
        }
    }
    
    @IBAction func goBackAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registrationAction(_ sender: UIButton) {
        view.endEditing(true)
        
        let height = respVHeight.constant
        let width = respVWidth.constant
        startResponse()
        
        registrationViewModel.registerUserWith() { [weak self] (status, message) in
            guard let self = self else { return }
            self.responseAI.stopAnimating()
            self.responseAI.isHidden = true
            if status {
                //success auth, show next VC
                self.finishResponse()
                self.respVWidth.constant = width
                self.respVHeight.constant = height
                self.dismiss(animated: true, completion: nil)
                self.pushNextVC()
            } else {
                //wrong auth, show animated view
                UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
                    self.responseLabel.text = message
                    self.responseLabel.isHidden = false
                    self.respVWidth.constant = 200
                    self.respVHeight.constant = 100
                    self.view.layoutIfNeeded()
                    self.responseView.layoutIfNeeded()
                }) { (success) in
                    if success {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                                self.respVWidth.constant = 0
                                self.respVHeight.constant = 0
                                self.view.layoutIfNeeded()
                                self.responseView.layoutIfNeeded()
                                self.responseLabel.isHidden = true
                            }) { (ready) in
                                if ready {
                                    self.finishResponse()
                                    self.respVWidth.constant = width
                                    self.respVHeight.constant = height
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func emailTFAction(_ sender: UITextField) {
    }
    
    @IBAction func passwordTFAction(_ sender: UITextField) {
    }
    
    func configLocalization() {
        emailTF.placeholder = R.string.localizable.emailPlaceholder()
        passwordTF.placeholder = R.string.localizable.passwordPlaceholder()
        registrationBtn.setTitle(R.string.localizable.registerBtn(), for: .normal)
    }
    
    func addTFDelegate() {
        emailTF.delegate = self
        passwordTF.delegate = self
    }
    
    func startResponse() {
        registrationBtn.isEnabled = false
        responseView.isHidden = false
        responseAI.startAnimating()
        responseAI.isHidden = false
        responseLabel.isHidden = true
    }
    
    func finishResponse() {
        self.responseView.isHidden = true
        self.registrationBtn.isEnabled = true
    }
    
    func pushNextVC() {
        if let vc = R.storyboard.simple().instantiateInitialViewController() {
            vc.modalTransitionStyle = .flipHorizontal
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
