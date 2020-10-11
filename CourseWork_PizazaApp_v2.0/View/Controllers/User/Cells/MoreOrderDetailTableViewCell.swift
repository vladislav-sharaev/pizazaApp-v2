//
//  MoreOrderDetailTableViewCell.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 10/7/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

class MoreOrderDetailTableViewCell: UITableViewCell {
    
    var indexPath: IndexPath!
    var basketElement: BasketElement!

    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ai: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func config() {
        hide(true)
        if let url = URL(string: basketElement.url) {
            UrlLoaderManager.shared.downloadImage(url: url) { (result) in
                switch result {
                case .success(let data):
                    let image = UIImage(data: data)
                    DispatchQueue.main.asyncAfter(deadline: .now() /*+ 0.1*/) {
                        self.foodImageView.image = image
                        self.hide(false)
                    }
                case .failure(let error):
                    self.foodImageView.image = .remove
                    self.hide(false)
                    print("Cant load human image in TableViewController")
                    print(error)
                }
            }
        }
    }
    
    private func hide(_ bool: Bool) {
        foodImageView.isHidden = bool
        nameLabel.isHidden = bool
        costLabel.isHidden = bool
        caloriesLabel.isHidden = bool
        countLabel.isHidden = bool
        ai.isHidden = !bool
        if !bool {
            ai.stopAnimating()
            nameLabel.text = basketElement.name
            costLabel.text = String(basketElement.cost.rounded(place: 2)) + " " + R.string.localizable.br()
            caloriesLabel.text = String(basketElement.calories.rounded(place: 2)) + " " + basketElement.cu
            countLabel.text = R.string.localizable.countTxt() + String(basketElement.count)
        }
        if bool {
            ai.startAnimating()
            foodImageView.image = nil
        }
    }
}
