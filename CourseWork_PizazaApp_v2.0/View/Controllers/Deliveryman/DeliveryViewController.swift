//
//  DeliverymanViewController.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 10/8/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

class DeliveryViewController: UIViewController {
    
    var deliveryViewModel = DeliveryViewModel()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ai: UIActivityIndicatorView!
    @IBOutlet weak var exitBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableDelegate()
        reload()
        configLocalization()
    }
    
    @IBAction func exitAction(_ sender: UIBarButtonItem) {
        deliveryViewModel.signOut { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //animateTable()
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        reload()
    }
    
    @IBAction func exit(_ sender: UIBarButtonItem) {
        deliveryViewModel.signOut { [weak self] (error) in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func configLocalization() {
        title = R.string.localizable.allOrdersTitle()
        exitBtn.title = R.string.localizable.exitBtn()
    }
    
    func addTableDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    func reload() {
        activateAI(bool: true)
        deliveryViewModel.config { [weak self] (error) in
            guard let self = self else { return }
            guard error == nil else { print(error?.localizedDescription as Any); return}
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.activateAI(bool: false)
                self.animateTable()
            }
        }
    }
    
    func activateAI(bool: Bool) {
        if bool {
            ai.isHidden = !bool
            ai.startAnimating()
        } else {
            ai.isHidden = !bool
            ai.stopAnimating()
        }
    }
    
}

extension DeliveryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveryViewModel.orderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.deliveryTableViewCell, for: indexPath) else {
            let cell = UITableViewCell()
            return cell
        }
        cell.indexPath = indexPath
        cell.orderElement = deliveryViewModel.orderArray[indexPath.row]
        cell.config()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func animateTable() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        
        let tableViewHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = R.storyboard.simple.orderDetailViewController() else { return }
        vc.order = deliveryViewModel.orderArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deliveryViewModel.makeCompleted(order: deliveryViewModel.orderArray[indexPath.row]) { [weak self] (error) in
                guard let self = self else { return }
                if let error = error {
                    print(error.localizedDescription as Any)
                } else {
                    self.reload()
                }
            }
        }
    }
}
