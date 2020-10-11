//
//  OrderHistoryTableViewCell.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 10/6/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

class OrderHistoryTableViewCell: UITableViewCell {
    
    var indexPath: IndexPath!
    var orderElement: Order!

    @IBOutlet weak var finalCostLabel: UILabel!
    @IBOutlet weak var onDateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func config() {
        finalCostLabel.text = String(orderElement.finalCost) + " " + R.string.localizable.br()
        onDateLabel.text = orderElement.onDate
        addressLabel.text = orderElement.address        
    }
}
