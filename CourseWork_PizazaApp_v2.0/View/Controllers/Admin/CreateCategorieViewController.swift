//
//  CreateCategorieViewController.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/20/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

class CreateCategorieViewController: UIViewController {
    
    var createCategorieViewModel = CreateCategorieViewModel()

    @IBOutlet weak var nameTF: BindingTextField! {
        didSet {
            nameTF.bind { self.createCategorieViewModel.nameT = $0 }
        }
    }
    @IBOutlet weak var urlTF: BindingTextField! {
        didSet {
            urlTF.bind { self.createCategorieViewModel.urlT = $0}
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextStep: UIBarButtonItem!
    @IBOutlet weak var newCategorieLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLocalication()
        addTFDelegate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.first != nil {
            view.endEditing(true)
        }
    }
    
    @IBAction func urlTFAction(_ sender: UITextField) {
        clearBadUrl()
    }
    
    @IBAction func nextStepAction(_ sender: UIBarButtonItem) {
        createCategorieViewModel.pushVC(image: imageView.image) { [weak self] (status) in
            guard let self = self else { return }
            if status {
                guard let vc = R.storyboard.admin.createFoodViewController() else { return }
                vc.createFoodViewModel.categorieImgUrl = self.createCategorieViewModel.urlT
                vc.createFoodViewModel.categorieName = self.createCategorieViewModel.nameT
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    @IBAction func urlTFAct(_ sender: UITextField) {
        clearBadUrl()
    }
    
    @IBAction func clearUrlBtn(_ sender: UIButton) {
        urlTF.text = ""
        createCategorieViewModel.urlT = ""
        clearBadUrl()
    }
    
    func addTFDelegate() {
        nameTF.delegate = self
        urlTF.delegate = self
    }
    
    func configLocalication() {
        self.title = R.string.localizable.navTitleCreateCategorie()
        nameTF.placeholder = R.string.localizable.categorieNamePlaceholder()
        urlTF.placeholder = R.string.localizable.imgUrlPlaceholder()
        nextStep.title = R.string.localizable.nextStepCreateCategorie()
    }
    
    func clearBadUrl() {
        createCategorieViewModel.loadImage() { [weak self] (status, data) in
            guard let self = self else { return }
            if status {
                guard let data = data else { return }
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.urlTF.text = ""
                }
            }
        }
    }
}

extension CreateCategorieViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
