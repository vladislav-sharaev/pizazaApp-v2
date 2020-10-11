//
//  CreateFoodViewController.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/21/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

class CreateFoodViewController: UIViewController {
    
    var createFoodViewModel = CreateFoodViewModel(categorieName: "", categorieImgUrl: "")

    @IBOutlet weak var categorieLabel: UILabel!
    @IBOutlet weak var nameTF: BindingTextField! {
        didSet {
            nameTF.bind { self.createFoodViewModel.name = $0 }
        }
    }
    @IBOutlet weak var ingridientsTF: BindingTextField! {
        didSet {
            ingridientsTF.bind { self.createFoodViewModel.ingridients = $0 }
        }
    }
    @IBOutlet weak var maxCaloriesTF: BindingTextField! {
        didSet {
            maxCaloriesTF.bind { self.createFoodViewModel.maxCalories = $0 }
        }
    }
    @IBOutlet weak var minCaloriesTF: BindingTextField! {
        didSet {
            minCaloriesTF.bind { self.createFoodViewModel.minCalories = $0 }
        }
    }
    @IBOutlet weak var maxCostTF: BindingTextField! {
        didSet {
            maxCostTF.bind { self.createFoodViewModel.maxCost = $0 }
        }
    }
    @IBOutlet weak var minCostTF: BindingTextField! {
        didSet {
            minCostTF.bind { self.createFoodViewModel.minCost = $0 }
        }
    }
    @IBOutlet weak var urlTF: BindingTextField! {
        didSet {
            urlTF.bind { self.createFoodViewModel.url = $0 }
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var cuTF: BindingTextField! {
        didSet {
            cuTF.bind { self.createFoodViewModel.cu = $0 }
        }
    }
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTFDelegate()
        configLocalization()
        checkTF()
        categorieLabel.text = createFoodViewModel.categorieName
        hideBtn()
        setTFWithFood()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = nameTF.text!
        setTFWithFood()
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.first != nil {
            view.endEditing(true)
        }
    }
    
    @IBAction func urlTFEdDidEnd(_ sender: UITextField) {
        clearBadUrl()
        checkTF()
    }
    
    @IBAction func urlTFEdChanged(_ sender: UITextField) {
        clearBadUrl()
        checkTF()
    }
    
    @IBAction func nameEdChanged(_ sender: UITextField) {
        checkTF()
    }
    
    @IBAction func maxCaloriesEdChanged(_ sender: UITextField) {
        checkTF()
        filterTF(textField: maxCaloriesTF)
    }
    
    @IBAction func maxCostEdChanged(_ sender: UITextField) {
        checkTF()
        filterTF(textField: maxCostTF)
    }
    
    @IBAction func cuTFEdChanged(_ sender: UITextField) {
        checkTF()
    }
    
    @IBAction func createAction(_ sender: UIButton) {
        createFood()
    }
    
    @IBAction func minCaloriesEdCh(_ sender: UITextField) {
        filterTF(textField: minCaloriesTF)
    }
    
    @IBAction func minCostEdCh(_ sender: UITextField) {
        filterTF(textField: minCostTF)
    }
    
    @IBAction func cleanBtnAction(_ sender: UIButton) {
        urlTF.text = ""
        createFoodViewModel.url = ""
        clearBadUrl()
        checkTF()
    }
    
    @IBAction func saveBtnAction(_ sender: UIBarButtonItem) {
        print(#function)
        createFood()
    }
    
    
    func addTFDelegate() {
        nameTF.delegate = self
        urlTF.delegate = self
        ingridientsTF.delegate = self
        maxCaloriesTF.delegate = self
        minCaloriesTF.delegate = self
        maxCostTF.delegate = self
        minCostTF.delegate = self
        cuTF.delegate = self
    }
    
    func configLocalization() {
        nameTF.placeholder = R.string.localizable.foodNamePlaceholder()
        urlTF.placeholder = R.string.localizable.imgUrlPlaceholder()
        ingridientsTF.placeholder = R.string.localizable.ingridientsPlaceholder()
        maxCaloriesTF.placeholder = R.string.localizable.maxCaloriesPlaceholder()
        minCaloriesTF.placeholder = R.string.localizable.minCaloriesPlaceholder()
        maxCostTF.placeholder = R.string.localizable.maxCostPlaceholder()
        minCostTF.placeholder = R.string.localizable.minCostPlaceholder()
        createBtn.setTitle(R.string.localizable.createBtn(), for: .normal)
        saveBtn.title = R.string.localizable.saveBtn()
    }
    
    func checkTF() {
        createBtn.isEnabled = false
        saveBtn.isEnabled = false
        createFoodViewModel.enableBtn(image: imageView.image) {
            self.createBtn.isEnabled = true
            self.saveBtn.isEnabled = true
        }
    }
    
    func clearBadUrl() {
        createFoodViewModel.loadImage() { [weak self] (status, data) in
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
    
    func filterTF(textField: UITextField) {
        guard let text = textField.text else { return }
        createFoodViewModel.filterTF(numberText: text) { (status) in
            if !status {
                textField.text = ""
                self.createBtn.isEnabled = false
                self.saveBtn.isEnabled = false
            }
        }
    }
    
    //hide saveBtn or createBtn and nameTF
    func hideBtn() {
        createFoodViewModel.needCreate { [weak self] (response) in
            guard let self = self else { return }
            if response {
                self.saveBtn.title = ""
                self.saveBtn.isEnabled = !response
                //self.createBtn.isHidden = !response
            } else {
                self.createBtn.isHidden = !response
                self.nameTF.isHidden = !response
                //self.saveBtn.title
            }
        }
    }
    
    //заполнить текстфилды
    func setTFWithFood() {
        guard let food = createFoodViewModel.food.food else { return }
        nameTF.text = food.name
        cuTF.text = food.cu
        ingridientsTF.text = food.ingridients
        maxCaloriesTF.text = String(food.maxCalories)
        maxCostTF.text = String(food.maxCost)
        urlTF.text = food.url
        
        //заполнить переменные, чтобы не были пустыми
        createFoodViewModel.name = food.name
        createFoodViewModel.url = food.url
        createFoodViewModel.cu = food.cu
        createFoodViewModel.ingridients = food.ingridients
        createFoodViewModel.maxCalories = String(food.maxCalories)
        createFoodViewModel.maxCost = String(food.maxCost)
        
        if let minCalories = food.minCalories {
            minCaloriesTF.text = String(minCalories)
            createFoodViewModel.minCalories = String(minCalories)
        }
        if let minCost = food.minCost {
            minCostTF.text = String(minCost)
            createFoodViewModel.minCost = String(minCost)
        }
        clearBadUrl()
    }
    
    //сколько экранов pop. Если создаём при создании категории, то до рута, иначе pop 1
    func popVC() {
        if let answ = createFoodViewModel.food.notAlone {
            print(answ)
            if answ {
                navigationController?.popViewController(animated: true)
            }
        } else {
            print("da on nil")
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func createFood() {
        createFoodViewModel.createNewFood() { (status) in
            if status {
                self.popVC()
            }
        }
    }
}

extension CreateFoodViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -10
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
}
