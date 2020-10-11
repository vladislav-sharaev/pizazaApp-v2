//
//  ViewController.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/8/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn
import PureLayout

class AuthViewController: UIViewController {
    
    var authViewModel = AuthViewModel()
    
    @IBOutlet weak var emailTF: BindingTextField! {
        didSet {
            emailTF.bind { self.authViewModel.emailT = $0 }
        }
    }
    @IBOutlet weak var passwordTF: BindingTextField! {
        didSet {
            passwordTF.bind { self.authViewModel.passwordT = $0 }
        }
    }
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    //view for errors
    @IBOutlet weak var responseView: UIView!
    @IBOutlet weak var respVHeight: NSLayoutConstraint!
    @IBOutlet weak var respVWidth: NSLayoutConstraint!
    @IBOutlet weak var responseAI: UIActivityIndicatorView!
    @IBOutlet weak var responseLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLocalization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showVC()
        addGoogleBtn()
        addTFDelegate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.first != nil {
            view.endEditing(true)
        }
    }
    
    @IBAction func emailTFAction(_ sender: UITextField) {
    }
    
    @IBAction func passwordAction(_ sender: UITextField) {
    }
    
    @IBAction func enterAction(_ sender: UIButton) {
        view.endEditing(true)
        
        let height = respVHeight.constant
        let width = respVWidth.constant
        startResponse()
        
        authViewModel.authenticateUserWith() { [weak self] (status, message) in
            guard let self = self else { return }
            self.responseAI.stopAnimating()
            self.responseAI.isHidden = true
            if status {
                //success auth, show next VC
                self.finishResponse()
                self.respVWidth.constant = width
                self.respVHeight.constant = height
                self.showVC()
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
    
    @IBAction func registrationAction(_ sender: UIButton) {
        guard let vc = R.storyboard.main.registrationViewController() else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        guard let vc = R.storyboard.main.forgotPasswordViewController() else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func configLocalization() {
        loginBtn.setTitle(R.string.localizable.loginBtn(), for: .normal)
        registerBtn.setTitle(R.string.localizable.registerBtn(), for: .normal)
        emailTF.placeholder = R.string.localizable.emailPlaceholder()
        passwordTF.placeholder = R.string.localizable.passwordPlaceholder()
        forgotPasswordBtn.setTitle(R.string.localizable.forgotPasswordBtn(), for: .normal)
    }
    
    func addTFDelegate() {
        emailTF.delegate = self
        passwordTF.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    func startResponse() {
        registerBtn.isEnabled = false
        forgotPasswordBtn.isEnabled = false
        loginBtn.isEnabled = false
        responseView.isHidden = false
        responseAI.startAnimating()
        responseAI.isHidden = false
        responseLabel.isHidden = true
    }
    
    func finishResponse() {
        registerBtn.isEnabled = true
        forgotPasswordBtn.isEnabled = true
        responseView.isHidden = true
        loginBtn.isEnabled = true
    }
    
    func addGoogleBtn() {
        self.view.addSubview(btn)
        btn.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
        btn.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
        btn.autoPinEdge(toSuperviewEdge: .bottom, withInset: 50)
        btn.addTarget(self, action: #selector(googleSignIn), for: .touchUpInside)
    }
    
    @objc func googleSignIn() {
        authViewModel.authenticareWithGoogle()
    }

    lazy var btn: GIDSignInButton = {
        let btn = GIDSignInButton()
        btn.style = .wide
        btn.colorScheme = GIDSignInButtonColorScheme.dark
        return btn
    }()
    
    func showVC() {
        authViewModel.getUserAndChangeVC { [weak self] (role) in
            guard let self = self else { return }
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
        }
    }
    
    private func presentVC(_ vc: UIViewController) {
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
