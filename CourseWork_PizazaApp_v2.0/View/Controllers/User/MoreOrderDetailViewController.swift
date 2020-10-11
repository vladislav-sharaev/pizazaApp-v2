//
//  MoreOrderDetailViewController.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 10/7/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

class MoreOrderDetailViewController: UIViewController {
    
    var order: Order!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableDelegate()

    }
    
    func addTableDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
}

extension MoreOrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.food.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.moreOrderDetailTableViewCell, for: indexPath) else {
            let cell = UITableViewCell()
            return cell
        }
        cell.indexPath = indexPath
        cell.basketElement = order.food[indexPath.row]
        cell.config()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
