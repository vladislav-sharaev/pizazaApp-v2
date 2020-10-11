//
//  CreateOrderViewController.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 10/2/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

class CreateOrderViewController: UIViewController {
    
    var createOrderViewModel = CreateOrderViewModel()
    var profileViewModel = ProfileSettingsViewModel()
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var finalCostLabel: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var telephoneTF: UITextField!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var porchTF: UITextField!
    @IBOutlet weak var floorTF: UITextField!
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var roomTF: UITextField!
    @IBOutlet weak var commentTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var createOrderBtn: UIButton!
    @IBOutlet weak var mapView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLocalization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        writeTF()
        timeTF.inputView = datePicker
        getDatePicker()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.first != nil {
            view.endEditing(true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getAddress" {
            let destVC = segue.destination as! MapViewController
            destVC.delegate = self
        }
    }
    
    @IBAction func telephoneTFEdDidEnd(_ sender: UITextField) {
        createOrderViewModel.outOfRange(textField: telephoneTF) { [weak self] (title, message) in
            guard let self = self else { return }
            self.showAlertWithoutAction(title: title, message: message)
        }
    }
    
    @IBAction func telephoneTFEdChanged(_ sender: UITextField) {
        filterTF(textField: telephoneTF)
    }
    
    @IBAction func createOrderBtnAction(_ sender: UIButton) {
        createOrderViewModel.order(nameTF: nameTF, telephoneTF: telephoneTF, adressLabel: adressLabel, dataTF: timeTF, finalCost: createOrderViewModel.finalCost, porchTF: porchTF, floorTF: floorTF, codeTF: codeTF, roomTF: roomTF) { [weak self] (success, title, message) in
            guard let self = self else { return }
            if !success {
                self.showAlertWithoutAction(title: title, message: message)
            } else {
                self.showAlertWithAction(title: title, message: message)
                SharedFactory.shared.basketViewModel.basketElementStorageCore.clearBasketElements()
            }
        }
    }
    
    func configLocalization() {
        title = R.string.localizable.createOrderTitle()
        dataLabel.text = R.string.localizable.dataText()
        nameTF.placeholder = R.string.localizable.nameTFPlaceholder()
        telephoneTF.placeholder = R.string.localizable.telephoneTFPlaceholder()
        porchTF.placeholder = R.string.localizable.porchPlaceholder()
        roomTF.placeholder = R.string.localizable.roomPlaceholder()
        floorTF.placeholder = R.string.localizable.floorPlaceholder()
        codeTF.placeholder = R.string.localizable.intercomePlaceholder()
        commentTF.placeholder = R.string.localizable.commentPlaceholder()
        timeTF.placeholder = R.string.localizable.timePlaceholder()
        createOrderBtn.setTitle(R.string.localizable.orderBtn(), for: .normal)
        
        //map view
        mapView.layer.borderColor = UIColor.lightGray.cgColor
        //finalCost label
        finalCostLabel.text = String(createOrderViewModel.finalCost) + " " + R.string.localizable.br()
    }
    
    func addTFDelegate() {
        nameTF.delegate = self
        telephoneTF.delegate = self
        porchTF.delegate = self
        roomTF.delegate = self
        floorTF.delegate = self
        codeTF.delegate = self
        commentTF.delegate = self
        timeTF.delegate = self
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
    
    func filterTF(textField: UITextField) {
        guard let text = textField.text else { return }
        profileViewModel.filterTF(numberText: text) { (status) in
            if !status {
                textField.text = ""
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
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getDatePicker() {
        datePicker.datePickerMode = .dateAndTime
        //ready button
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpace, doneButton], animated: true)
        timeTF.inputAccessoryView = toolBar
        
        let plusHour = Calendar.current.date(byAdding: .hour, value: 1, to: Date())
        datePicker.minimumDate = plusHour
    }
    
    @objc func doneAction(tf: UITextField) {
        getDateFromPicker()
        view.endEditing(true)
    }
    
    private func getDateFromPicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        timeTF.text = formatter.string(from: datePicker.date)
    }
}

extension CreateOrderViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension CreateOrderViewController: MapViewControllerDelegate {
    func getAdress(adress: String) {
        DispatchQueue.main.async {
            self.adressLabel.text = adress
        }
    }
}
