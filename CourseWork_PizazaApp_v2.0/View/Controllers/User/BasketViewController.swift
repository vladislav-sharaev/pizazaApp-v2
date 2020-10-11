//
//  BasketViewController.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/30/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

class BasketViewController: UIViewController {
    
    var basketViewModel = BasketViewModel()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var removeAllBtn: UIBarButtonItem!
    //under table view
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var createOrderBtn: UIButton!
    @IBOutlet weak var totalCostText: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView()
        configLocalization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTable()
        showHideTable()
    }
    
    @IBAction func createOrderBtn(_ sender: UIButton) {
        basketViewModel.pushVC(selfVC: self)
    }
    
    @IBAction func removeAllElements(_ sender: UIBarButtonItem) {
        basketViewModel.basketElementStorageCore.clearBasketElements()
        updateTable()
        showHideTable()
    }
    
    
    func addTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    func configLocalization() {
        title = R.string.localizable.basketTitle()
        totalCostText.text = R.string.localizable.totalCostTxt()
        createOrderBtn.setTitle(R.string.localizable.createOrder(), for: .normal)
    }
    
    func updateTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.updateLabel()
            self.showBadge()
        }
    }
    
    func showHideTable() {
        tableView.isHidden = basketViewModel.needShowTable()
        orderView.isHidden = basketViewModel.needShowTable()
        removeAllBtn.isEnabled = !basketViewModel.needShowTable()
    }
    
    func updateLabel() {
        totalCostLabel.text = String(basketViewModel.returnTotalCost()) + " " + R.string.localizable.br()
    }
    
    func showAlertWithAction() {
        let alert = UIAlertController(title: R.string.localizable.addToBasketAlertTitle(), message: R.string.localizable.addToBasketMessage(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alert) in
            self.navigationController?.popToRootViewController(animated: true)
            }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketViewModel.basketArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.basketTableViewCell, for: indexPath) else {
            let cell = UITableViewCell()
            return cell
        }
        cell.indexPath = indexPath
        cell.basketElement = basketViewModel.basketArray[indexPath.row]
        cell.delegate = self
        cell.config()
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            basketViewModel.basketElementStorageCore.deleteBasketElement(basketViewModel.basketArray[indexPath.row])
            updateTable()
            showHideTable()
        }
    }
    
    private func showBadge() {
        if let items = tabBarController?.tabBar.items {
            items[1].badgeValue = String(SharedFactory.shared.basketViewModel.basketArray.count)
        }
    }
}

extension BasketViewController: BasketTableViewCellDelegate {
    func changeCount(elementWith indexPath: IndexPath, onNumber: Int) {
        //basketViewModel.getRealm()
        basketViewModel.basketElementStorageCore.changeBasketElementCount(basketViewModel.basketArray[indexPath.row], number: onNumber)
        updateLabel()
    }
}
