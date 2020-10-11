//
//  EditCategorieViewController.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/22/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

class EditCategorieViewController: UIViewController {
    
    var editCategorieViewModel = EditCategorieViewModel(categorie: Categorie(url: "", name: ""))

    @IBOutlet weak var urlTF: BindingTextField! {
        didSet {
            urlTF.bind { self.editCategorieViewModel.url = $0 }
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLocalization()
        addTFDelegate()
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = editCategorieViewModel.categorie.name
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.first != nil {
            view.endEditing(true)
        }
    }
    
    @IBAction func urlTFEdDidEnd(_ sender: UITextField) {
        clearBadUrl()
    }
    
    @IBAction func cleanBtnAction(_ sender: UIButton) {
        urlTF.text = ""
        editCategorieViewModel.url = ""
        clearBadUrl()
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        editCategorieViewModel.popVC(image: imageView.image) { [weak self] (status) in
            guard let self = self else { return }
            if status {
                self.editCategorieViewModel.save() { [weak self] (ready) in
                    guard let self = self else { return }
                    if ready {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    func configUI() {
        let url = editCategorieViewModel.categorie.url
        urlTF.text = url
        clearBadUrl()
    }
    
    func addTFDelegate() {
        urlTF.delegate = self
    }
    
    func configLocalization() {
        urlTF.placeholder = R.string.localizable.imgUrlPlaceholder()
        
    }
    
    func clearBadUrl() {
        editCategorieViewModel.loadImage() { [weak self] (status, data) in
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

extension EditCategorieViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
