//
//  ForgotPasswordViewController.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/10/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit


class ForgotPasswordViewController: UIViewController {
    
    var forgotPasswordViewModel = ForgotPasswordViewModel()

    @IBOutlet weak var emailTF: BindingTextField! {
        didSet {
            emailTF.bind { self.forgotPasswordViewModel.emailT = $0}
        }
    }
    @IBOutlet weak var changePasswordBtn: UIButton!
    
    //view for error
    @IBOutlet weak var responseView: UIView!
    @IBOutlet weak var respVHeight: NSLayoutConstraint!
    @IBOutlet weak var respVWidth: NSLayoutConstraint!
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var responseAI: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLocalization()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.first != nil {
            view.endEditing(true)
        }
    }
    
    @IBAction func emailTFAction(_ sender: UITextField) {
    }
    
    @IBAction func changePassAction(_ sender: UIButton) {
        view.endEditing(true)
        
        changePasswordBtn.isEnabled = false
        let height = respVHeight.constant
        let width = respVWidth.constant
        responseView.isHidden = false
        responseAI.startAnimating()
        responseAI.isHidden = false
        responseLabel.isHidden = true
        
        forgotPasswordViewModel.changePasswordWith() { [weak self] (status, message) in
            guard let self = self else { return }
            self.responseAI.stopAnimating()
            self.responseAI.isHidden = true
            //success, show animated view and dismiss
            //wrong email, show animated view
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
                                self.responseView.isHidden = true
                                self.changePasswordBtn.isEnabled = true
                                self.respVWidth.constant = width
                                self.respVHeight.constant = height
                                if status {
                                    self.dismiss(animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func goBackAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func configLocalization() {
        changePasswordBtn.setTitle(R.string.localizable.changePasswordBtn(), for: .normal)
        emailTF.placeholder = R.string.localizable.emailPlaceholder()
    }
}
