//
//  OneFoodViewController.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/29/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

class OneFoodViewController: UIViewController {
    
    var oneFoodViewModel = OneFoodViewModel()
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var standartSizeBtn: UIButton!
    @IBOutlet weak var smallSizeBtn: UIButton!
    @IBOutlet weak var standartLabel: UILabel!
    @IBOutlet weak var smallLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var ingridientsLabel: UILabel!
    @IBOutlet weak var productCountLabel: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLocalization()
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func standartSizeBtnAction(_ sender: UIButton) {
        oneFoodViewModel.size = .standart
        oneFoodViewModel.makeSelected(that: standartLabel, and: standartSizeBtn, insteadOf: smallLabel, and: smallSizeBtn)
        oneFoodViewModel.changeCostAndCaloriesLabels(size: oneFoodViewModel.size, caloriesLabel: caloriesLabel, costLabel: costLabel)
    }
    
    @IBAction func smallSizeBtnAction(_ sender: UIButton) {
        oneFoodViewModel.size = .min
        oneFoodViewModel.makeSelected(that: smallLabel, and: smallSizeBtn, insteadOf: standartLabel, and: standartSizeBtn)
        oneFoodViewModel.changeCostAndCaloriesLabels(size: oneFoodViewModel.size, caloriesLabel: caloriesLabel, costLabel: costLabel)
    }
    
    @IBAction func plusBtnAction(_ sender: UIButton) {
        oneFoodViewModel.increaseFoodCount(1, label: productCountLabel)
    }
    
    @IBAction func minusBtnAction(_ sender: UIButton) {
        oneFoodViewModel.increaseFoodCount(-1, label: productCountLabel)
    }
    
    @IBAction func addToCartBtnAction(_ sender: UIButton) {
        oneFoodViewModel.addFoodToBasket()
        showBadge()
        showAlertWithAction()
    }
    
    func configLocalization() {
        addToCartBtn.setTitle(R.string.localizable.addToCartBtn(), for: .normal)
        standartSizeBtn.setTitle(R.string.localizable.standartSize(), for: .normal)
        smallSizeBtn.setTitle(R.string.localizable.smallSize(), for: .normal)
    }
    
    func config() {
        oneFoodViewModel.makeSelected(that: standartLabel, and: standartSizeBtn, insteadOf: smallLabel, and: smallSizeBtn)
        oneFoodViewModel.config { [weak self] (image) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.foodImageView.image = image
            }
        }
        
        nameLabel.text = oneFoodViewModel.food.name
        ingridientsLabel.text = oneFoodViewModel.food.ingridients
        oneFoodViewModel.changeCostAndCaloriesLabels(size: oneFoodViewModel.size, caloriesLabel: caloriesLabel, costLabel: costLabel)
        oneFoodViewModel.makeSmallSizeBtnEnable(smallSizeBtn)
    }
    
    private func showBadge() {
        if let items = tabBarController?.tabBar.items {
            items[1].badgeValue = String(SharedFactory.shared.basketViewModel.basketArray.count)
        }
    }
    
    func showAlertWithAction() {
        let alert = UIAlertController(title: R.string.localizable.addToBasketAlertTitle(), message: R.string.localizable.addToBasketMessage(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alert) in
            self.navigationController?.popToRootViewController(animated: true)
            }))
        self.present(alert, animated: true, completion: nil)
    }
}
